import 'package:flutter/material.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.sectionTitle.copyWith(color: palette.textPrimary),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
