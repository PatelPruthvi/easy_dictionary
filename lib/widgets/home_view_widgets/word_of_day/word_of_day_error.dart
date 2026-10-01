import 'package:flutter/material.dart';

import '../../../utils/colors/app_palette.dart';
import '../../../utils/theme/app_theme.dart';
import '../../../view_model/home_view_model.dart';

class WordOftheDayError extends StatelessWidget {
  const WordOftheDayError({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: palette.error, size: 30),
          const SizedBox(height: 5),
          Text(
            "Couldn't load Word of the Day",
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            viewModel.errorMessageForWOD ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed:
                viewModel.isWordLoading ? null : viewModel.retryWordOfTheDay,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: const Center(child: Text('Retry')),
            ),
          ),
        ],
      ),
    );
  }
}
