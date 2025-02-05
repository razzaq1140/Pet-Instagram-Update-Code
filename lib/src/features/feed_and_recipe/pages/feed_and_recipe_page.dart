import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/features/feed_and_recipe/pages/feed_view_page.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';

import '../controller/recipe_controller.dart';
import 'my_recipe_page.dart';
import 'upload_recipe_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int selectedIndex = 0;
  bool isFeedSelected = true;
  final PageController _pageController = PageController(initialPage: 0);
  late RecipeController _recipeController;
  @override
  void initState() {
    _recipeController = Provider.of<RecipeController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  if (isFeedSelected) _recipeController.recipeList.clear();
                  isFeedSelected = index == 0;
                });
              },
              children: const [
                FeedViewPage(),
                RecipePage(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              color: colorScheme(context).surface,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme(context).onPrimary,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color:
                                colorScheme(context).outline.withOpacity(0.06),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFeedSelected = true;
                                  });
                                  _pageController.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: isFeedSelected
                                        ? colorScheme(context).primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'feed'.tr(),
                                        style: TextStyle(
                                          color: isFeedSelected
                                              ? colorScheme(context).surface
                                              : colorScheme(context)
                                                  .outline
                                                  .withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.grid_view_outlined,
                                          color: isFeedSelected
                                              ? colorScheme(context).onSecondary
                                              : AppColor.hintText),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFeedSelected = false;
                                  });
                                  _pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: !isFeedSelected
                                        ? colorScheme(context).primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'My Recipes',
                                        style: TextStyle(
                                          color: !isFeedSelected
                                              ? colorScheme(context).surface
                                              : colorScheme(context)
                                                  .outline
                                                  .withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(MdiIcons.dockLeft,
                                          color: !isFeedSelected
                                              ? colorScheme(context).onSecondary
                                              : AppColor.hintText),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: const UploadRecipePage(),
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme(context).primary.withOpacity(0.5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme(context).primary,
                          ),
                          child: Icon(
                            Icons.add_box_outlined,
                            size: 24,
                            color: colorScheme(context).surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
