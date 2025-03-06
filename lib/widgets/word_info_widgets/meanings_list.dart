import 'package:flutter/material.dart';

import '../../models/dictionary_model.dart';
import '../../utils/colors/app_colors.dart';
import '../../view_model/word_info_view_model.dart';

class MeaningsList extends StatelessWidget {
  const MeaningsList(
      {super.key, required this.wordInfoModel, required this.viewModel});

  final DictionaryModel wordInfoModel;
  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            wordInfoModel.meanings[viewModel.dropdownIdx].definitions.length,
        itemBuilder: (context, idx) {
          return MeaningListItem(
              definition: wordInfoModel
                  .meanings[viewModel.dropdownIdx].definitions[idx],
              idx: idx,
              viewModel: viewModel);
        });
  }
}

class MeaningListItem extends StatelessWidget {
  const MeaningListItem(
      {super.key,
      required this.definition,
      required this.viewModel,
      required this.idx});

  final Definition definition;
  final WordInfoViewModel viewModel;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "${idx + 1}.",
                  style: const TextStyle(
                      fontFamily: 'Varela',
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.definition,
                      style: const TextStyle(
                          fontFamily: 'Varela',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    definition.example == null
                        ? const SizedBox(height: 0, width: 0)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(color: AppColors.kGrey),
                              const Text(
                                'e.g',
                                style: TextStyle(
                                    fontFamily: 'Varela',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.kDarkPurple),
                              ),
                              Text(
                                definition.example ?? "",
                                style: const TextStyle(
                                  fontFamily: 'Varela',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
