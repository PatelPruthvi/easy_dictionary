import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors/app_palette.dart';
import '../../utils/theme/app_theme.dart';
import '../../utils/theme/theme_controller.dart';
import '../../view_model/home_view_model.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/home_view_widgets/blog/blog_item.dart';
import '../../widgets/home_view_widgets/recent_search/recent_search_chip.dart';
import '../../widgets/home_view_widgets/recent_search/recent_search_empty.dart';
import '../../widgets/home_view_widgets/search_word.dart';
import '../../widgets/home_view_widgets/word_of_day/word_of_day.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter a word  ✍🏻',
          style: AppTheme.sectionTitle.copyWith(color: palette.textPrimary),
        ),
        actions: [
          Consumer<ThemeController>(
            builder: (context, themeCtrl, _) => IconButton(
              tooltip: themeCtrl.isDark ? 'Switch to light' : 'Switch to dark',
              icon: Icon(
                themeCtrl.isDark
                    ? Icons.wb_sunny_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: themeCtrl.toggle,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWord(viewModel: viewModel),
              const CustomDivider(),
              SectionHeader(
                title: 'Word of the Day 📚',
                action: _ShuffleButton(viewModel: viewModel),
              ),
              WordOfTheDay(viewModel: viewModel),
              const CustomDivider(),
              SectionHeader(
                title: 'Recent Searches 🔎',
                action: viewModel.recentSearches.isEmpty
                    ? null
                    : TextButton(
                        onPressed: viewModel.clearRecentSearches,
                        style: TextButton.styleFrom(
                          foregroundColor: palette.textSecondary,
                        ),
                        child: const Text('Clear all'),
                      ),
              ),
              viewModel.recentSearches.isEmpty
                  ? const RecentSearchEmpty()
                  : RecentSearchChip(viewModel: viewModel),
              const CustomDivider(),
              const SectionHeader(title: 'Word Stories ✨'),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: viewModel.wordStories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    BlogListItem(blog: viewModel.wordStories[index]),
              ),
              const CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShuffleButton extends StatelessWidget {
  const _ShuffleButton({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return IconButton(
      tooltip: 'Show another word',
      onPressed: viewModel.isWordLoading ? null : viewModel.shuffleWordOfTheDay,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(palette.accentOrange),
      ),
      icon: const Icon(Icons.shuffle_rounded, size: 18),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      child: Divider(color: AppPalette.of(context).divider),
    );
  }
}
