import 'package:flutter/material.dart';

import '../../models/dictionary_model.dart';
import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';

class WordFormsSection extends StatelessWidget {
  const WordFormsSection({super.key, required this.forms});

  final List<WordForm> forms;

  @override
  Widget build(BuildContext context) {
    if (forms.isEmpty) return const SizedBox.shrink();

    final palette = AppPalette.of(context);
    final grouped = <String, List<String>>{};
    for (final form in forms) {
      grouped.putIfAbsent(form.label, () => []).add(form.word);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          color: palette.cardLavender,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Forms',
              style: AppTheme.sectionTitle.copyWith(color: palette.textPrimary),
            ),
            for (final group in grouped.entries)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.key,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      group.value.join(' · '),
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
