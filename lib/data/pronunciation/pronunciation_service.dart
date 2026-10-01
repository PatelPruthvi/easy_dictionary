// `dart:async` is aliased because this app defines its own TimeoutException in
// data/exception/app_exceptions.dart, which would otherwise shadow the one
// `Future.timeout` throws and silently skip the catch clauses below.
import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../exception/app_exceptions.dart';

/// Speaks words with the device text-to-speech engine.
///
/// The dictionary API ships IPA transcriptions but no audio files, so
/// pronunciation is synthesised locally - which also covers every language the
/// device has a voice for.
class PronunciationService {
  PronunciationService._();

  static final PronunciationService instance = PronunciationService._();

  /// Every call is bounded: on Android the first request has to connect to the
  /// TTS engine, and if that connection never completes the platform future
  /// hangs forever and leaves the caller's spinner spinning.
  static const Duration _timeout = Duration(seconds: 5);

  /// Created on first use: constructing [FlutterTts] opens a platform channel,
  /// which is not available until the bindings are up (and never in tests).
  FlutterTts? _ttsOrNull;

  /// Cached only once the engine actually reports voices. An empty list means
  /// the engine was not ready yet, so it must not be cached as the answer.
  List<String>? _languages;
  bool _configured = false;

  FlutterTts get _tts => _ttsOrNull ??= FlutterTts();

  Future<void> _configure(FlutterTts tts) async {
    if (_configured) return;
    await tts.setSpeechRate(0.45).timeout(_timeout);
    await tts.setVolume(1.0).timeout(_timeout);
    await tts.setPitch(1.0).timeout(_timeout);
    _configured = true;
  }

  /// BCP-47 tags the engine can speak, e.g. `en-US`, lower-cased.
  Future<List<String>> _loadLanguages(FlutterTts tts) async {
    final cached = _languages;
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      final languages = await tts.getLanguages.timeout(_timeout);
      final parsed = (languages as List?)
              ?.whereType<String>()
              .map((language) => language.toLowerCase())
              .toList() ??
          const <String>[];
      if (parsed.isNotEmpty) _languages = parsed;
      return parsed;
    } catch (error) {
      // Not fatal: we fall back to the engine's own default voice.
      debugPrint('[TTS] Could not list languages: $error');
      return const [];
    }
  }

  /// Resolves a dictionary language code such as `pt` to an installed voice,
  /// or null when the engine reported nothing to match against.
  String? _matchLanguage(List<String> languages, String languageCode) {
    final code = languageCode.toLowerCase();
    for (final candidate in languages) {
      if (candidate == code) return candidate;
    }
    for (final candidate in languages) {
      if (candidate.startsWith('$code-') || candidate.startsWith('${code}_')) {
        return candidate;
      }
    }
    return null;
  }

  /// Speaks [text]; throws an [AppException] when the engine cannot do it.
  Future<void> speak({
    required String text,
    required String languageCode,
  }) async {
    final word = text.trim();
    if (word.isEmpty) throw AudioNotAvailableException();

    final tts = _tts;
    try {
      await _configure(tts);

      final languages = await _loadLanguages(tts);
      final tag = _matchLanguage(languages, languageCode);
      if (tag == null && languages.isNotEmpty) {
        // The engine knows its voices and none of them covers this language.
        throw PronunciationUnavailableException();
      }

      // Stop anything still playing so a second tap restarts cleanly rather
      // than queueing behind the previous utterance.
      await tts.stop().timeout(_timeout);
      if (tag != null) await tts.setLanguage(tag).timeout(_timeout);

      final result = await tts.speak(word).timeout(_timeout);
      if (result == 0) throw AudioUnableToPlayException();
    } on async.TimeoutException {
      // Make the next attempt re-negotiate instead of reusing bad state.
      _configured = false;
      _languages = null;
      throw AudioUnableToPlayException();
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[TTS] speak failed: $error\n$stackTrace');
      throw AudioUnableToPlayException();
    }
  }

  Future<void> stop() async {
    try {
      await _ttsOrNull?.stop().timeout(_timeout);
    } catch (error) {
      debugPrint('[TTS] stop failed: $error');
    }
  }
}
