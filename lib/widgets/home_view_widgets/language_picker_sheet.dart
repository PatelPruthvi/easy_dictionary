import 'package:flutter/material.dart';

import '../../models/language_model.dart';
import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../view_model/home_view_model.dart';
import '../common/tag_pill.dart';

class LanguagePickerSheet extends StatefulWidget {
  const LanguagePickerSheet({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static Future<LanguageModel?> show(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    return showModalBottomSheet<LanguageModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LanguagePickerSheet(viewModel: viewModel),
    );
  }

  @override
  State<LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<LanguagePickerSheet> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final palette = AppPalette.of(context);
    final results = viewModel.languages
        .where((language) => language.matches(_query))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 44,
              decoration: BoxDecoration(
                color: palette.divider,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search language',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          viewModel.isLanguagesLoading
                              ? 'Loading languages…'
                              : '${viewModel.languages.length} languages available',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _queryController,
                textInputAction: TextInputAction.search,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Type a language…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _queryController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            if (_query.isEmpty && viewModel.suggestedLanguages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.suggestedLanguages.map((language) {
                      final selected =
                          language.code == viewModel.selectedLanguage.code;
                      return TagPill(
                        label: language.name,
                        background: selected
                            ? palette.accentPurple
                            : palette.cardPurple,
                        onTap: () => Navigator.of(context).pop(language),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: results.isEmpty
                  ? _EmptyResults(query: _query)
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final language = results[index];
                        final selected =
                            language.code == viewModel.selectedLanguage.code;
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius),
                          ),
                          selected: selected,
                          selectedTileColor: palette.cardPurple,
                          onTap: () => Navigator.of(context).pop(language),
                          leading: Container(
                            height: 38,
                            width: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? palette.accentPurple
                                  : palette.tagDefault,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                            ),
                            child: Text(
                              language.code.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                          ),
                          title: Text(
                            language.name,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: palette.textPrimary,
                            ),
                          ),
                          subtitle: language.words == 0
                              ? null
                              : Text(
                                  language.wordCountLabel,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 12,
                                    color: palette.textSecondary,
                                  ),
                                ),
                          trailing: selected
                              ? Icon(Icons.check_circle_rounded,
                                  color: palette.strongPurple, size: 20)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.travel_explore_outlined,
              size: 40, color: palette.textFaint),
          const SizedBox(height: 12),
          Text(
            'No language matches "$query"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
