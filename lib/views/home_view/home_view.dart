import 'package:easy_dictionary/widgets/home_view_widgets/recent_search/recent_search_empty.dart';
import 'package:easy_dictionary/widgets/home_view_widgets/search_word.dart';
import 'package:easy_dictionary/widgets/home_view_widgets/word_of_day/word_of_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_dictionary/models/word_stories_model.dart';
import 'package:easy_dictionary/utils/colors/app_colors.dart';
import 'package:easy_dictionary/widgets/home_view_widgets/blog/blog_loader.dart';
import '../../view_model/home_view_model.dart';
import '../../widgets/home_view_widgets/blog/blog_item.dart';
import '../../widgets/home_view_widgets/recent_search/recent_search_chip.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Enter a word  ✍🏻',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWord(viewModel: viewModel),
                    const CustomDivider(),
                    const Text(
                      'Word of the Day 📚',
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    WordOfTheDay(viewModel: viewModel),
                    const CustomDivider(),
                    const Text(
                      "Recent Searches 🔎",
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    viewModel.recentSearches.isEmpty
                        ? const RecentSearchEmpty()
                        : RecentSearchChip(viewModel: viewModel),
                    const CustomDivider(),
                    const Text(
                      'Word Stories ✨',
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.wordStories.length,
                        itemBuilder: (context, index) {
                          WordStoriesModel blog = viewModel.wordStories[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: viewModel.isBlogLoading
                                ? const BlogLoader()
                                : BlogListItem(blog: blog),
                          );
                        }),
                    const CustomDivider(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      child: Divider(color: AppColors.kGrey),
    );
  }
}
