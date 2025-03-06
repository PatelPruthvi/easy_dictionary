import 'package:easy_dictionary/utils/utils.dart';
import 'package:easy_dictionary/widgets/word_info_widgets/meanings_list.dart';
import 'package:flutter/material.dart';

import '../../models/dictionary_model.dart';
import '../../utils/colors/app_colors.dart';
import '../../view_model/word_info_view_model.dart';

class WordInfo extends StatefulWidget {
  const WordInfo(
      {super.key, required this.viewModel, required this.wordInfoModel});

  final WordInfoViewModel viewModel;
  final DictionaryModel wordInfoModel;

  @override
  State<WordInfo> createState() => _WordInfoState();
}

class _WordInfoState extends State<WordInfo> with TickerProviderStateMixin {
  late AnimationController progressController;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          color: AppColors.kLightPurple,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.wordInfoModel.word,
                style: const TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              IconButton.filled(
                  color: Colors.black,
                  onPressed: () async {
                    await widget.viewModel
                        .playAudio()
                        .onError((err, stacktrace) {
                      progressController = AnimationController(
                          vsync: this, duration: const Duration(seconds: 5));
                      if (mounted) {
                        progressController.reset();
                        progressController.forward();
                      }
                      Utils.showFlushbar(
                              title: "Unable to play audio.",
                              content: err.toString(),
                              progressController: progressController)
                          .show(context);
                    });
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.kMediumPurple),
                  icon: widget.viewModel.isAudioLoading
                      ? const SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.volume_up_outlined))
            ],
          ),
          Text(
            widget.wordInfoModel.phonetic ??
                widget.wordInfoModel.phonetics
                    .firstWhere(
                      (phon) => phon.text != null,
                      orElse: () => Phonetic(text: ""),
                    )
                    .text ??
                "",
          ),
          const SizedBox(height: 30),
          WordDropdown(
              wordInfoModel: widget.wordInfoModel, viewModel: widget.viewModel),
          MeaningsList(
              wordInfoModel: widget.wordInfoModel, viewModel: widget.viewModel),
        ],
      ),
    );
  }
}

class WordDropdown extends StatelessWidget {
  const WordDropdown(
      {super.key, required this.wordInfoModel, required this.viewModel});

  final DictionaryModel wordInfoModel;
  final WordInfoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.kMediumPurple,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: DropdownButton(
          elevation: 8,
          isExpanded: true,
          underline: const Text(''),
          borderRadius: BorderRadius.circular(10),
          value: viewModel.dropdownIdx,
          style: const TextStyle(
              fontFamily: 'Varela',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: [
            for (int i = 0; i < wordInfoModel.meanings.length; i++)
              DropdownMenuItem<int>(
                  value: i, child: Text(wordInfoModel.meanings[i].partOfSpeech))
          ],
          onChanged: (val) {
            viewModel.changeDropdownIndex(val ?? 0);
          }),
    );
  }
}
