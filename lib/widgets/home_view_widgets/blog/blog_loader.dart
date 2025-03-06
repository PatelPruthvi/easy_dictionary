import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/app_colors.dart';

class BlogLoader extends StatelessWidget {
  const BlogLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.kLightPurple),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Container(
                    height: 5,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Container(
                    height: 5,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: AppColors.kGrey,
                  highlightColor: AppColors.kLightGrey,
                  child: Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Shimmer.fromColors(
              baseColor: AppColors.kGrey,
              highlightColor: AppColors.kLightGrey,
              child: Container(
                height: 10,
                width: 20,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
