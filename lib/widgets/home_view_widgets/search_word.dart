import 'package:easy_dictionary/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/utils.dart';
import '../../views/word_info_view/word_info_view.dart';

class SearchWord extends StatefulWidget {
  final HomeViewModel viewModel;
  const SearchWord({super.key, required this.viewModel});

  @override
  State<SearchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<SearchWord> with TickerProviderStateMixin {
  late AnimationController progressController;
  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: widget.viewModel.wordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: widget.viewModel.isSearchButtonVisible
                      ? IconButton(
                          icon: const Icon(Icons.highlight_remove_outlined),
                          onPressed: () {
                            widget.viewModel.wordController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          widget.viewModel.isSearchButtonVisible
              ? SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.black),
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.kOrange),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 20)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: widget.viewModel.isLoading
                        ? null // Disable button while loading
                        : () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            await widget.viewModel.searchWord().then((val) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WordInfoView(
                                      wordInfoModel:
                                          widget.viewModel.searchedWord!),
                                ),
                              );
                              widget.viewModel.wordController.clear();
                            }).onError((err, stacktrace) {
                              progressController = AnimationController(
                                vsync: this, // Provide vsync
                                duration: const Duration(seconds: 5),
                              );
                              if (mounted) {
                                progressController
                                    .reset(); // Reset before starting
                                progressController.forward();
                              }
                              Utils.showFlushbar(
                                      title: "No Definitions Found.",
                                      content: err.toString(),
                                      progressController: progressController)
                                  .show(context);
                            });
                          },
                    child: widget.viewModel.isLoading
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
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
