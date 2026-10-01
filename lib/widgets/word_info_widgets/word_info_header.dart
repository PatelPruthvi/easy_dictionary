import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../utils/utils.dart';
import '../../view_model/word_info_view_model.dart';
import 'meanings_list.dart';

class WordInfo extends StatelessWidget {
  const WordInfo({super.key, required this.viewModel});

  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final model = viewModel.wordInfoModel;
    final palette = AppPalette.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: palette.cardPurple,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.word,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Copy word',
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(palette.accentPurple),
                ),
                color: palette.textPrimary,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: model.word));
                  Utils.showInfo(
                    context,
                    title: 'Word copied to clipboard!',
                    icon: Icons.copy_outlined,
                  );
                },
                icon: const Icon(Icons.copy_outlined),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Pronounce',
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(palette.accentPurple),
                ),
                color: palette.textPrimary,
                onPressed: viewModel.isAudioLoading
                    ? null
                    : () async {
                        try {
                          await viewModel.speak();
                        } catch (error) {
                          if (!context.mounted) return;
                          Utils.showError(
                            context,
                            title: 'Unable to play audio.',
                            message: error.toString(),
                          );
                        }
                      },
                icon: viewModel.isAudioLoading
                    ? SizedBox(
                        height: 12,
                        width: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.textPrimary,
                        ),
                      )
                    : const Icon(Icons.volume_up_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),
          WordDropdown(viewModel: viewModel),
          MeaningsList(viewModel: viewModel),
        ],
      ),
    );
  }
}

class WordDropdown extends StatelessWidget {
  const WordDropdown({super.key, required this.viewModel});

  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final labels = viewModel.wordInfoModel.entryLabels;
    final palette = AppPalette.of(context);

    if (labels.length < 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          labels.isEmpty ? '' : labels.first,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: palette.textPrimary,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        color: palette.accentPurple,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton<int>(
        elevation: 8,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        value: viewModel.entryIndex,
        style: TextStyle(
          fontFamily: AppTheme.fontFamily,
          color: palette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: palette.accentPurple,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: palette.textPrimary),
        items: [
          for (int i = 0; i < labels.length; i++)
            DropdownMenuItem<int>(value: i, child: Text(labels[i])),
        ],
        onChanged: (value) => viewModel.changeEntryIndex(value ?? 0),
      ),
    );
  }
}
