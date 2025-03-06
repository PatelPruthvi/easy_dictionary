import 'package:flutter/material.dart';

import '../../../models/word_stories_model.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../views/blog_view/blog_view.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem({
    super.key,
    required this.blog,
  });

  final WordStoriesModel blog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogView(wordStoriesModel: blog)));
      },
      child: Card(
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tileColor: AppColors.kLightPurple,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              blog.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Varela'),
            ),
          ),
          subtitle: Text(
            blog.content,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(fontFamily: 'Varela'),
          ),
          trailing: Text(blog.readingTime),
        ),
      ),
    );
  }
}
