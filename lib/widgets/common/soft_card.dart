import 'package:flutter/material.dart';

import '../../utils/theme/app_theme.dart';

/// The flat, rounded pastel surface the cards across the app sit on.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    required this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.radius);

    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: padding,
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
