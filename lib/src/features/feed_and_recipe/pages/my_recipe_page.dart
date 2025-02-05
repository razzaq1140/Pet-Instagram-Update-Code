import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '/src/common/constants/app_images.dart';
import '/src/features/feed_and_recipe/controller/recipe_controller.dart';
import '/src/features/feed_and_recipe/widget/recipe_post.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_shimmer.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late RecipeController _recipeController;
  @override
  void initState() {
    _recipeController = Provider.of<RecipeController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_recipeController.firstTimeLoadingMyRecipes) {
        _recipeController.toggleLoading();
        await _recipeController.fetchMyRecipeFeed();
        _recipeController.toggleLoading();
      }
    });
  }

  Future<void> onRefresh() async {
    _recipeController.clearRecipe();
    _recipeController.toggleLoading();
    await _recipeController.fetchRecipeFeed();
    _recipeController.toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'my_recipe_post'.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 20, color: colorScheme(context).onSurface),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                  onTap: () => context.pushNamed(AppRoute.notificationPage),
                  child: SvgPicture.asset(AppIcons.notiIcon)),
            ],
          ),
        ),
        backgroundColor: colorScheme(context).onPrimary,
        body: Consumer<RecipeController>(
          builder: (context, recipeController, widget) {
            if (recipeController.isLoading) {
              return CustomShimmer(
                height: MediaQuery.of(context).size.height,
              );
            } else if (recipeController.myRecipeList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No Recipe found '),
                    TextButton(
                        onPressed: onRefresh, child: const Text('Refresh'))
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: recipeController.myRecipeList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RecipePostWidget(
                    post: recipeController.myRecipeList[index]!,
                  );
                });
          },
        ),
      ),
    );
  }
}
