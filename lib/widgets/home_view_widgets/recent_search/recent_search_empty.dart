import 'package:flutter/material.dart';

import '../../../utils/colors/app_palette.dart';
import '../../../utils/theme/app_theme.dart';
import '../../common/soft_card.dart';

class RecentSearchEmpty extends StatelessWidget {
  const RecentSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return SoftCard(
      color: palette.cardBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Recent Searches',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Start searching for words and they'll appear here!",
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
