import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/dictionary_model.dart';
import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../utils/utils.dart';
import '../../view_model/word_info_view_model.dart';
import '../../widgets/word_info_widgets/source_credits.dart';
import '../../widgets/word_info_widgets/word_forms.dart';
import '../../widgets/word_info_widgets/word_info_header.dart';
import '../../widgets/word_info_widgets/word_list.dart';

class WordInfoView extends StatelessWidget {
  const WordInfoView({super.key, required this.wordInfoModel});

  final DictionaryModel wordInfoModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordInfoViewModel(wordInfoModel: wordInfoModel),
      child: const _WordInfoBody(),
    );
  }
}

class _WordInfoBody extends StatelessWidget {
  const _WordInfoBody();

  Future<void> _openRelated(
    BuildContext context,
    WordInfoViewModel viewModel,
    String word,
  ) async {
    if (viewModel.isLookupLoading) return;
    try {
      final related = await viewModel.lookupRelated(word);
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WordInfoView(wordInfoModel: related),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      Utils.showError(
        context,
        title: 'No entry for "$word"',
        message: error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WordInfoViewModel>();
    final model = viewModel.wordInfoModel;
    final entry = viewModel.currentEntry;
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(model.word.toUpperCase()),
        bottom: viewModel.isLookupLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
          child: Column(
            children: [
              WordInfo(viewModel: viewModel),
              if (model.pronunciations.isNotEmpty)
                _PronunciationsCard(pronunciations: model.pronunciations),
              WordList(
                title: 'Synonyms',
                words: entry.allSynonyms,
                backgroundColor: palette.cardGreen,
                foregroundColor: palette.accentGreen,
                onWordTap: (word) => _openRelated(context, viewModel, word),
              ),
              WordList(
                title: 'Antonyms',
                words: entry.allAntonyms,
                backgroundColor: palette.cardOrange,
                foregroundColor: palette.accentOrange,
                onWordTap: (word) => _openRelated(context, viewModel, word),
              ),
              WordFormsSection(forms: model.forms),
              SourceCredits(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class _PronunciationsCard extends StatelessWidget {
  const _PronunciationsCard({required this.pronunciations});

  final List<Pronunciation> pronunciations;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.cardBlue,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        children: pronunciations.take(4).map((p) {
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: p.text,
                  style: AppTheme.ipaStyle.copyWith(
                    fontSize: 14,
                    color: palette.textPrimary,
                  ),
                ),
                if (p.accent.isNotEmpty)
                  TextSpan(
                    text: '  ${p.accent}',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 11,
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
