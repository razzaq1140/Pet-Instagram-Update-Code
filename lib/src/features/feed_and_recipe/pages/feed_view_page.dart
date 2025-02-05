import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/feed_and_recipe/controller/recipe_controller.dart';
import '/src/features/feed_and_recipe/widget/feed_post.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common/widget/custom_shimmer.dart';

class FeedViewPage extends StatefulWidget {
  const FeedViewPage({super.key});

  @override
  State<FeedViewPage> createState() => _FeedViewPageState();
}

class _FeedViewPageState extends State<FeedViewPage> {
  late RecipeController _recipeController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _recipeController = Provider.of<RecipeController>(context, listen: false);
    _recipeController.feedScrollController = ScrollController();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _recipeController.feedScrollController
          .addListener(_recipeController.scrollListener);
      if (_recipeController.firstTimeLoadingFeed) {
        _recipeController.toggleLoading();
        await _recipeController.fetchRecipeFeed();
        _recipeController.toggleLoading();
      }
    });
  }

  String selectedCategory = 'all'.tr();

  final List<String> categories = [
    'all'.tr(),
    'dogs'.tr(),
    'cats'.tr(),
    'birds'.tr(),
    'fish'.tr()
  ];

  Future<void> onRefresh() async {
    _recipeController.clearRecipe();
    _recipeController.toggleLoading();
    await _recipeController.fetchRecipeFeed();
    _recipeController.toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).onPrimary,
      appBar: AppBar(
        toolbarHeight: 130,
        title: Column(
          children: [
            CustomTextFormField(
              controller: searchController,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(AppIcons.outlineSearch),
              ),
              readOnly: false,
              hint: 'search_hint'.tr(),
              borderColor: colorScheme(context).outline.withOpacity(0.4),
              fillColor: colorScheme(context).surface,
              onFieldSubmitted: (value) async {
                _recipeController.toggleLoading();
                await _recipeController
                    .fetchSearchRecipeFeed(searchController.text);
                _recipeController.toggleLoading();
              },
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 17),
                child: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              suffixConstraints: const BoxConstraints(minHeight: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ChoiceChip(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: colorScheme(context).outline.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    showCheckmark: false,
                    onSelected: (selected) {
                      setState(() {
                        if (categories[index] == 'all'.tr()) {
                          selectedCategory = 'all'.tr();
                          searchController.clear();
                          _recipeController.toggleLoading();
                          _recipeController.fetchRecipeFeed();
                          _recipeController.toggleLoading();
                        } else {
                          selectedCategory = categories[index];
                        }
                      });
                    },
                    selectedColor: colorScheme(context).primary,
                    backgroundColor: Colors.transparent,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: onRefresh,
        child: Consumer<RecipeController>(
          builder: (context, recipeController, widget) {
            var filteredRecipeList = selectedCategory == 'all'.tr()
                ? recipeController.recipeList
                : recipeController.recipeList.where((post) {
                    return post.category == selectedCategory;
                  }).toList();

            var searchFilteredRecipeList = filteredRecipeList.where((post) {
              return post.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  post.category
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  post.preparationSteps
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase());
            }).toList();

            if (recipeController.isLoading) {
              return CustomShimmer(
                height: MediaQuery.of(context).size.height,
              );
            }

            if (searchFilteredRecipeList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No Recipe Found'),
                    TextButton(
                        onPressed: onRefresh, child: const Text('Refresh'))
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: searchFilteredRecipeList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (recipeController.currentPage < recipeController.totalPage) {
                  return Column(
                    children: [
                      FeedPostWidget(post: searchFilteredRecipeList[index]),
                      if (index == searchFilteredRecipeList.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text('Loading ...'),
                            ],
                          ),
                        ),
                    ],
                  );
                }
                return FeedPostWidget(post: searchFilteredRecipeList[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
