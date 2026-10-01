import 'package:flutter/material.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';

class TagPill extends StatelessWidget {
  const TagPill({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.icon,
    this.onTap,
  });

  final String label;
  final Color? background;
  final Color? foreground;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final fg = foreground ?? palette.textPrimary;
    final radius = BorderRadius.circular(999);

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: background ?? palette.tagDefault,
      borderRadius: radius,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, borderRadius: radius, child: content),
    );
  }
}
