import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/colors/app_palette.dart';
import '../../../utils/theme/app_theme.dart';
import '../../../utils/utils.dart';
import '../../../utils/word_navigator.dart';
import '../../../view_model/home_view_model.dart';
import 'wod_loader.dart';
import 'word_of_day_error.dart';

class WordOfTheDay extends StatelessWidget {
  const WordOfTheDay({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        color: palette.cardOrange,
      ),
      child: viewModel.isWordLoading && viewModel.wordOfTheDay == null
          ? const WordOfTheDayLoader()
          : viewModel.wordOfTheDay == null
              ? WordOftheDayError(viewModel: viewModel)
              : _WordOfTheDayContent(viewModel: viewModel),
    );
  }
}

class _WordOfTheDayContent extends StatelessWidget {
  const _WordOfTheDayContent({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final word = viewModel.wordOfTheDay!;
    final entry = word.entries.first;
    final palette = AppPalette.of(context);

    return InkWell(
      onTap: () => WordNavigator.open(context, word),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (word.primaryPronunciation != null)
                      Text(
                        word.primaryPronunciation!,
                        style: AppTheme.ipaStyle.copyWith(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy word',
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(palette.accentOrange),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: word.word));
                  Utils.showInfo(
                    context,
                    title: 'Word copied to clipboard!',
                    icon: Icons.copy_outlined,
                  );
                },
                icon: const Icon(Icons.copy_outlined),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Pronounce',
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(palette.accentOrange),
                ),
                onPressed: viewModel.isAudioLoading
                    ? null
                    : () async {
                        try {
                          await viewModel.speakWordOfTheDay();
                        } catch (error) {
                          if (!context.mounted) return;
                          Utils.showError(
                            context,
                            title: 'Could not play audio.',
                            message: error.toString(),
                          );
                        }
                      },
                icon: viewModel.isAudioLoading
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.textPrimary,
                        ),
                      )
                    : const Icon(Icons.volume_up_outlined),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
            child: Text(
              entry.partOfSpeech,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontStyle: FontStyle.italic,
                color: palette.textPrimary,
              ),
            ),
          ),
          Text(
            word.previewDefinition ?? '',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
