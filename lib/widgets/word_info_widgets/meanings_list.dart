import 'package:flutter/material.dart';

import '../../models/dictionary_model.dart';
import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../view_model/word_info_view_model.dart';

class MeaningsList extends StatelessWidget {
  const MeaningsList({super.key, required this.viewModel});

  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final senses = viewModel.currentEntry.senses;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: senses.length,
      itemBuilder: (context, index) => MeaningListItem(
        sense: senses[index],
        idx: index,
        senseKey: '${viewModel.entryIndex}-$index',
        viewModel: viewModel,
      ),
    );
  }
}

class MeaningListItem extends StatelessWidget {
  const MeaningListItem({
    super.key,
    required this.sense,
    required this.idx,
    required this.senseKey,
    required this.viewModel,
  });

  final Sense sense;
  final int idx;
  final String senseKey;
  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '${idx + 1}.',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: palette.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sense.definition,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: palette.textPrimary,
                    ),
                  ),
                  if (sense.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        sense.tags.join(' · '),
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: palette.strongPurple,
                        ),
                      ),
                    ),
                  if (sense.examples.isNotEmpty) _Examples(sense: sense),
                  if (sense.subsenses.isNotEmpty)
                    _Subsenses(sense: sense, parentIdx: idx),
                  if (sense.quotes.isNotEmpty)
                    _Quotes(
                      quotes: sense.quotes,
                      expanded: viewModel.isQuotesExpanded(senseKey),
                      onToggle: () => viewModel.toggleQuotes(senseKey),
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

class _Examples extends StatelessWidget {
  const _Examples({required this.sense});

  final Sense sense;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: palette.divider),
        Text(
          'e.g',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: palette.strongPurple,
          ),
        ),
        for (final example in sense.examples)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              example,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: palette.textPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

class _Subsenses extends StatelessWidget {
  const _Subsenses({required this.sense, required this.parentIdx});

  final Sense sense;
  final int parentIdx;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sense.subsenses.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${parentIdx + 1}.${i + 1}',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sense.subsenses[i].definition,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 13,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Quotes extends StatelessWidget {
  const _Quotes({
    required this.quotes,
    required this.expanded,
    required this.onToggle,
  });

  final List<Quote> quotes;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.format_quote_rounded,
                    size: 15, color: palette.strongPurple),
                const SizedBox(width: 5),
                Text(
                  expanded
                      ? 'Hide citations'
                      : '${quotes.length} citation${quotes.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: palette.strongPurple,
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 16,
                  color: palette.strongPurple,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: !expanded
              ? const SizedBox(width: double.infinity)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: quotes.map((quote) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: palette.cardBlue,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${quote.text}"',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12.5,
                                height: 1.45,
                                color: palette.textPrimary,
                              ),
                            ),
                            if (quote.reference != null &&
                                quote.reference!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  quote.reference!,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 11,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
