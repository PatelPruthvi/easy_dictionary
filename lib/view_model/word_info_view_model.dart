import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_dictionary/data/exception/app_exceptions.dart';
import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WordInfoViewModel extends ChangeNotifier {
  final DictionaryModel wordInfoModel;
  int dropdownIdx = 0;
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool isAudioLoading = false;

  WordInfoViewModel({required this.wordInfoModel});

  void changeDropdownIndex(int index) {
    dropdownIdx = index;
    notifyListeners();
  }

  Future<void> playAudio() async {
    String? audioUrl = wordInfoModel.phonetics
        .firstWhere((phonetic) => phonetic.audio != null,
            orElse: () => Phonetic(audio: ""))
        .audio;

    if (!_isPlaying) {
      if (audioUrl != null && audioUrl.isNotEmpty) {
        isAudioLoading = true;
        notifyListeners();
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none)) {
          isAudioLoading = false;
          notifyListeners();
          throw AudioUnableToPlayException();
        }
        await _audioPlayer.setSourceUrl(audioUrl).then((val) {
          _audioPlayer.resume();
          _isPlaying = true;
          isAudioLoading = false;
          notifyListeners();
        }).timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            isAudioLoading = false;
            _isPlaying = false;
            notifyListeners();
            throw AudioUnableToPlayException();
          },
        );

        _audioPlayer.onPlayerComplete.listen(cancelOnError: true, (_) {
          _isPlaying = false;
          notifyListeners();
        });
      } else {
        throw AudioNotAvailableException();
      }
    }
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    bool canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(uri);
    } else {
      // HANDLE ERROR
      throw UrlCannotLaunchException();
    }
  }
}
