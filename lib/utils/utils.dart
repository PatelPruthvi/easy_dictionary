import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'colors/app_palette.dart';
import 'theme/app_theme.dart';

class Utils {
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final palette = AppPalette.of(context);
    _flushbar(
      title: title,
      message: message,
      icon: Icons.warning_amber_rounded,
      accent: palette.error,
      background: palette.cardPeach,
    ).show(context);
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    String? message,
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    final palette = AppPalette.of(context);
    _flushbar(
      title: title,
      message: message,
      icon: icon,
      accent: palette.strongPurple,
      background: palette.cardPeach,
    ).show(context);
  }

  static Flushbar _flushbar({
    required String title,
    required String? message,
    required IconData icon,
    required Color accent,
    required Color background,
  }) {
    return Flushbar(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      borderRadius: BorderRadius.circular(12),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.decelerate,
      backgroundColor: background,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
      isDismissible: true,
      duration: const Duration(seconds: 4),
      icon: Icon(icon, color: accent, size: 28),
      titleText: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.black87,
        ),
      ),
      messageText: message == null || message.isEmpty
          ? const SizedBox.shrink()
          : Text(
              message,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
    );
  }
}
