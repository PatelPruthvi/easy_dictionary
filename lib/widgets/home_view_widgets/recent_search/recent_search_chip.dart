import 'package:flutter/material.dart';

import '../../../utils/colors/app_palette.dart';
import '../../../utils/theme/app_theme.dart';
import '../../../utils/word_navigator.dart';
import '../../../view_model/home_view_model.dart';

class RecentSearchChip extends StatelessWidget {
  const RecentSearchChip({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    final palette = AppPalette.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: viewModel.recentSearches.map((recent) {
        return Material(
          color: palette.accentBlue,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: () =>
                WordNavigator.search(context, viewModel, recent: recent),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        recent.languageCode.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        recent.word,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Remove',
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minHeight: 26, minWidth: 26),
                    padding: EdgeInsets.zero,
                    iconSize: 15,
                    color: palette.textSecondary,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => viewModel.removeFromRecentSearches(recent),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
