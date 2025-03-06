import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';

class RecentSearchEmpty extends StatelessWidget {
  const RecentSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.kLightBlue),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No Recent Searches",
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 6),
          Text(
            "Start searching for words and they'll appear here!",
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontFamily: 'Varela'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
