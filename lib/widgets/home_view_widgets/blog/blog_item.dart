import 'package:flutter/material.dart';

import '../../../models/word_stories_model.dart';
import '../../../utils/colors/app_palette.dart';
import '../../../utils/theme/app_theme.dart';
import '../../../views/blog_view/blog_view.dart';
import '../../common/soft_card.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem({super.key, required this.blog});

  final WordStoriesModel blog;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return SoftCard(
      color: palette.cardPurple,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BlogView(wordStoriesModel: blog)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  blog.title,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                blog.readingTime,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            blog.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
