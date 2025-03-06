import 'package:easy_dictionary/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/dictionary_model.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/utils.dart';
import '../../../views/word_info_view/word_info_view.dart';
import 'wod_loader.dart';
import 'word_of_day_error.dart';

class WordOfTheDay extends StatefulWidget {
  final HomeViewModel viewModel;

  const WordOfTheDay({super.key, required this.viewModel});

  @override
  State<WordOfTheDay> createState() => _WordOfTheDayState();
}

class _WordOfTheDayState extends State<WordOfTheDay>
    with TickerProviderStateMixin {
  late AnimationController progressController;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.kLightOrange),
        child: widget.viewModel.isWordLoading
            ? const WordOfTheDayLoader()
            : widget.viewModel.errorMessageForWOD != null
                ? WordOftheDayError(viewModel: widget.viewModel)
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WordInfoView(
                                  wordInfoModel:
                                      widget.viewModel.wordOfTheDay!)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.viewModel.wordOfTheDay?.word ?? "",
                                    style: const TextStyle(
                                        fontFamily: 'Varela',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.viewModel.wordOfTheDay?.phonetic ??
                                        widget.viewModel.wordOfTheDay?.phonetics
                                            .firstWhere(
                                              (phon) => phon.text != null,
                                              orElse: () => Phonetic(text: ""),
                                            )
                                            .text ??
                                        "",
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.kOrange)),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          widget.viewModel.wordOfTheDay?.word ??
                                              ""));
                                  Fluttertoast.showToast(
                                    msg: "Word copied to clipboard!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                },
                                icon: const Icon(Icons.copy_outlined)),
                            IconButton(
                                style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.kOrange)),
                                onPressed: () async {
                                  widget.viewModel.isAudioLoading
                                      ? null
                                      : await widget.viewModel
                                          .playAudio()
                                          .onError((err, stacktrace) {
                                          progressController =
                                              AnimationController(
                                            vsync: this, // Provide vsync
                                            duration:
                                                const Duration(seconds: 5),
                                          );
                                          if (mounted) {
                                            progressController
                                                .reset(); // Reset before starting
                                            progressController.forward();
                                          }
                                          Utils.showFlushbar(
                                                  title:
                                                      "Could not play audio.",
                                                  content: err.toString(),
                                                  progressController:
                                                      progressController)
                                              .show(context);
                                        });
                                },
                                icon: widget.viewModel.isAudioLoading
                                    ? const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black),
                                      )
                                    : const Icon(Icons.volume_up_outlined)),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Text(
                            widget.viewModel.wordOfTheDay?.meanings.first
                                    .partOfSpeech ??
                                "",
                            style: const TextStyle(
                                fontFamily: 'Varela',
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Text(
                          widget.viewModel.wordOfTheDay?.meanings.first
                                  .definitions.first.definition ??
                              "",
                          style: const TextStyle(fontFamily: 'Varela'),
                        )
                      ],
                    ),
                  ));
  }
}
