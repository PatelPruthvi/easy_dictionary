// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_dictionary/utils/utils.dart';
import 'package:easy_dictionary/view_model/word_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_dictionary/models/dictionary_model.dart';
import 'package:easy_dictionary/utils/colors/app_colors.dart';
import 'package:provider/provider.dart';
import '../../widgets/word_info_widgets/word_info_header.dart';
import '../../widgets/word_info_widgets/word_list.dart';

class WordInfoView extends StatefulWidget {
  final DictionaryModel wordInfoModel;
  const WordInfoView({super.key, required this.wordInfoModel});
  @override
  State<WordInfoView> createState() => _WordInfoViewState();
}

class _WordInfoViewState extends State<WordInfoView>
    with TickerProviderStateMixin {
  late AnimationController progressController;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (ctx) =>
                WordInfoViewModel(wordInfoModel: widget.wordInfoModel))
      ],
      child: Consumer<WordInfoViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(widget.wordInfoModel.word.toUpperCase()),
            titleTextStyle: const TextStyle(
                fontFamily: 'Varela',
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  WordInfo(
                      wordInfoModel: widget.wordInfoModel,
                      viewModel: viewModel),
                  WordList(
                    title: 'Synonyms',
                    words: widget
                        .wordInfoModel.meanings[viewModel.dropdownIdx].synonyms,
                    backgroundColor: AppColors.kLightGreen,
                    foregroundColor: AppColors.kGreen,
                  ),
                  WordList(
                    title: 'Antonyms',
                    words: widget
                        .wordInfoModel.meanings[viewModel.dropdownIdx].antonyms,
                    backgroundColor: AppColors.kLightOrange,
                    foregroundColor: AppColors.kOrange,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.kLightBlue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Credits',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.black),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              AppColors.kBlue)),
                                  icon: const Icon(Icons.file_open_outlined),
                                  onPressed: () async {
                                    await viewModel
                                        .openUrl(widget.wordInfoModel.sourceUrls
                                                ?.first ??
                                            "")
                                        .onError((err, stacktrace) {
                                      progressController = AnimationController(
                                          vsync: this,
                                          duration: const Duration(seconds: 5));
                                      if (mounted) {
                                        progressController.reset();
                                        progressController.forward();
                                      }
                                      Utils.showFlushbar(
                                              title: "Unable to open url.",
                                              content: err.toString(),
                                              progressController:
                                                  progressController)
                                          .show(context);
                                    });
                                  },
                                  label: const Text('SOURCES')),
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.black),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              AppColors.kBlue)),
                                  icon: const Icon(Icons.source_outlined),
                                  onPressed: () async {
                                    await viewModel.openUrl(
                                        widget.wordInfoModel.license?.url ??
                                            '');
                                  },
                                  label: const Text('LICENSE')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
