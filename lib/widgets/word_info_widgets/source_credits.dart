import 'package:flutter/material.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../utils/utils.dart';
import '../../view_model/word_info_view_model.dart';

class SourceCredits extends StatelessWidget {
  const SourceCredits({super.key, required this.viewModel});

  final WordInfoViewModel viewModel;

  Future<void> _open(BuildContext context, String url) async {
    try {
      await viewModel.openUrl(url);
    } catch (error) {
      if (!context.mounted) return;
      Utils.showError(
        context,
        title: 'Unable to open url.',
        message: error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final source = viewModel.wordInfoModel.source;
    if (source == null) return const SizedBox.shrink();
    final license = source.license;
    final palette = AppPalette.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          color: palette.cardBlue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credits',
              style: AppTheme.sectionTitle.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              license == null
                  ? 'Definitions sourced from Wiktionary.'
                  : 'Definitions sourced from Wiktionary, licensed under ${license.name}.',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (source.url.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.accentBlue,
                    ),
                    icon: const Icon(Icons.file_open_outlined, size: 18),
                    onPressed: () => _open(context, source.url),
                    label: const Text('SOURCES'),
                  ),
                if (license != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.accentBlue,
                    ),
                    icon: const Icon(Icons.source_outlined, size: 18),
                    onPressed: () => _open(context, license.url),
                    label: const Text('LICENSE'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
