import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/app_palette.dart';

class WordOfTheDayLoader extends StatelessWidget {
  const WordOfTheDayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Shimmer.fromColors(
      baseColor: palette.shimmerBase,
      highlightColor: palette.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bar(height: 22, width: 100, color: palette.background),
          const SizedBox(height: 6),
          _Bar(height: 12, width: 80, color: palette.background),
          const SizedBox(height: 24),
          _Bar(height: 14, width: 100, color: palette.background),
          const SizedBox(height: 14),
          _Bar(height: 12, width: double.infinity, color: palette.background),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.width, required this.color});

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, width: width, color: color);
  }
}
