import 'package:flutter/material.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../utils/word_navigator.dart';
import '../../view_model/home_view_model.dart';
import 'language_picker_sheet.dart';

class SearchWord extends StatelessWidget {
  const SearchWord({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  Future<void> _pickLanguage(BuildContext context) async {
    final language = await LanguagePickerSheet.show(context, viewModel);
    if (language != null) await viewModel.selectLanguage(language);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: viewModel.wordController,
                    textInputAction: TextInputAction.search,
                    enabled: !viewModel.isLoading,
                    onSubmitted: (_) =>
                        WordNavigator.search(context, viewModel),
                    decoration: InputDecoration(
                      hintText: 'Enter word here...',
                      suffixIcon: viewModel.isSearchButtonVisible
                          ? IconButton(
                              icon: const Icon(
                                Icons.highlight_remove_outlined,
                              ),
                              onPressed: viewModel.clearSearchField,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              if (viewModel.isSearchButtonVisible) ...[
                const SizedBox(width: 5),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () => WordNavigator.search(context, viewModel),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _LanguageButton(
            viewModel: viewModel,
            onTap: () => _pickLanguage(context),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.viewModel, required this.onTap});

  final HomeViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final radius = BorderRadius.circular(999);

    return Material(
      color: palette.cardBlue,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language_outlined, size: 16, color: palette.textPrimary),
              const SizedBox(width: 6),
              Text(
                'Searching in ${viewModel.selectedLanguage.name}',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.expand_more_rounded, size: 18, color: palette.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
