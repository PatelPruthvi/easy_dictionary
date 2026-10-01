import 'package:flutter/material.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.title,
    required this.words,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onWordTap,
    this.maxVisible = 24,
  });

  final String title;
  final List<String> words;
  final Color backgroundColor;
  final Color foregroundColor;
  final ValueChanged<String>? onWordTap;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) return const SizedBox.shrink();

    final palette = AppPalette.of(context);
    final visible = words.take(maxVisible).toList();
    final hidden = words.length - visible.length;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTheme.sectionTitle.copyWith(color: palette.textPrimary),
                ),
                const SizedBox(width: 8),
                Text(
                  '${words.length}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 14,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final word in visible)
                  _WordChip(
                    label: word,
                    color: foregroundColor,
                    onTap: onWordTap == null ? null : () => onWordTap!(word),
                  ),
                if (hidden > 0)
                  _WordChip(label: '+$hidden more', color: foregroundColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.label, required this.color, this.onTap});

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final chip = Chip(
      labelStyle: TextStyle(
        fontFamily: AppTheme.fontFamily,
        color: palette.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      label: Text(label),
      side: const BorderSide(color: Colors.transparent),
      backgroundColor: color,
    );

    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: chip,
    );
  }
}
