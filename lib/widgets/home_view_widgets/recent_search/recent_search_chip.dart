import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../view_model/home_view_model.dart';
import '../../../views/word_info_view/word_info_view.dart';

class RecentSearchChip extends StatelessWidget {
  final HomeViewModel viewModel;
  const RecentSearchChip({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: viewModel.recentSearches.map((word) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GestureDetector(
                onTap: () async {
                  await viewModel.searchRecentSearches(word).then((val) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WordInfoView(
                                wordInfoModel: viewModel.searchedWord!)));
                    viewModel.wordController.clear();
                  });
                },
                child: Chip(
                  labelStyle: const TextStyle(
                      fontFamily: 'Varela',
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  label: Text(word),
                  side: const BorderSide(color: Colors.transparent),
                  backgroundColor: AppColors.kBlue,
                ),
              ),
            ),
            Positioned(
              right: -1,
              child: InkWell(
                onTap: () {
                  viewModel.removeFromRecentSearches(word);
                },
                child:
                    Icon(Icons.remove_circle, size: 18, color: AppColors.kRed),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
