// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_dictionary/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:easy_dictionary/models/word_stories_model.dart';

class BlogView extends StatelessWidget {
  final WordStoriesModel wordStoriesModel;
  const BlogView({super.key, required this.wordStoriesModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Learning Section',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Varela'),
        ),
        backgroundColor: AppColors.kLavendarTint,
      ),
      backgroundColor: AppColors.kLavendarTint,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wordStoriesModel.title,
                style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Varela'),
              ),
              const SizedBox(height: 20),
              Text(
                'Reading Time : ${wordStoriesModel.readingTime}',
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontFamily: 'Varela'),
              ),
              const SizedBox(height: 20),
              Text(
                wordStoriesModel.content,
                style: const TextStyle(fontSize: 24, fontFamily: 'Varela'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
