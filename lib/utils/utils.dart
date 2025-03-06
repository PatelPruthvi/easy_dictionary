import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'colors/app_colors.dart';

class Utils {
  static Flushbar showFlushbar(
      {required String title,
      required String content,
      required AnimationController progressController}) {
    return Flushbar(
      shouldIconPulse: true,
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      borderRadius: BorderRadius.circular(12),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.easeOutBack, // Smooth opening animation
      backgroundColor: AppColors.kPeach,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4), // Drop shadow effect
        )
      ],
      isDismissible: true, // Allow dismissal on tap/swipe
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.warning_amber_rounded, color: AppColors.kRed, size: 28),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: AppColors.kDarkPurple,
      progressIndicatorController: progressController,

      progressIndicatorValueColor:
          const AlwaysStoppedAnimation<Color>(Colors.redAccent),
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          fontFamily: "Varela",
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        content,
        style: const TextStyle(
          fontSize: 16.0,
          fontFamily: 'Varela',
          color: Colors.black54,
        ),
      ),
    );
  }
}
