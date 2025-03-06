import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/app_colors.dart';

class WordOfTheDayLoader extends StatelessWidget {
  const WordOfTheDayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.kGrey,
            highlightColor: AppColors.kLightGrey,
            child: Container(
              height: 22,
              width: 100,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Shimmer.fromColors(
              baseColor: AppColors.kGrey,
              highlightColor: AppColors.kLightGrey,
              child: Container(
                height: 12,
                width: 80,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Shimmer.fromColors(
              baseColor: AppColors.kGrey,
              highlightColor: AppColors.kLightGrey,
              child: Container(
                height: 14,
                width: 100,
                color: Colors.white,
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: AppColors.kGrey,
            highlightColor: AppColors.kLightGrey,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
