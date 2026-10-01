import 'package:flutter/material.dart';

import '../../models/word_stories_model.dart';
import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key, required this.wordStoriesModel});

  final WordStoriesModel wordStoriesModel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Learning Section',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        backgroundColor: palette.cardLavender,
      ),
      backgroundColor: palette.cardLavender,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wordStoriesModel.title,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reading Time : ${wordStoriesModel.readingTime}',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontStyle: FontStyle.italic,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                wordStoriesModel.content,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 18,
                  height: 1.6,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
