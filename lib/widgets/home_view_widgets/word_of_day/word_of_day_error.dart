import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../view_model/home_view_model.dart';

class WordOftheDayError extends StatelessWidget {
  final HomeViewModel viewModel;
  const WordOftheDayError({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off, color: AppColors.kRed, size: 30),
        const SizedBox(height: 5),
        const Text(
          "Couldn't load Word of the Day",
          style: TextStyle(
              fontFamily: 'Varela', fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          viewModel.errorMessageForWOD ?? "",
          style: const TextStyle(
              fontFamily: 'Varela', fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            viewModel.fetchWordOfTheDay();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColors.kOrange),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: const Center(
              child: Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ),
        )
      ],
    );
  }
}
