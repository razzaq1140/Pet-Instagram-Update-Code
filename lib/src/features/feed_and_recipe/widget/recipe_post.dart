import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/widget/custom_comments.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/feed_and_recipe/controller/recipe_controller.dart';
import '/src/features/feed_and_recipe/widget/expnadable_recipe_text_widget.dart';
import '/src/features/home/widget/show_full_screen_image.dart';
import '/src/models/recipe_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../profile/pages/my_profile_page.dart';

class RecipePostWidget extends StatefulWidget {
  final MyRecipe post;

  const RecipePostWidget({
    super.key,
    required this.post,
  });

  @override
  State<RecipePostWidget> createState() => RecipePostWidgetState();
}

class RecipePostWidgetState extends State<RecipePostWidget> {
  bool isFavorite = false;
  bool isBookmarked = false;

  final PageController _pageController = PageController();
  int currentIndex = 0;
  late RecipeController _recipeController;
  late UserController _userController;
  int commmentCount = 0;
  @override
  void initState() {
    super.initState();
    isFavorite = widget.post.likedByUser;
    isBookmarked = widget.post.savedByUser;
    _userController = Provider.of<UserController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recipeController = Provider.of<RecipeController>(context, listen: false);
      _userController = Provider.of<UserController>(context, listen: false);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String changeToTimeAgo(DateTime date) {
    String timeAgo = timeago.format(date);
    return timeAgo;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: colorScheme(context).onSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const MyProfilePage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                        child: Image.network(
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      _userController.user!.profileImage,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.pets,
                          size: 40,
                          color: colorScheme(context).primary.withOpacity(0.8)),
                    )),
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const MyProfilePage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userController.user!.name.isEmpty
                            ? _userController.user!.username
                            : _userController.user!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: colorScheme(context).outline),
                      ),
                      Text(
                        changeToTimeAgo(
                            DateTime.parse(widget.post.createdAt.toString())),
                        style: const TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Report') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reported this post')),
                      );
                    } else if (value == 'Block') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Blocked this user')),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Report', 'Block'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            _buildStaggeredImages(),
            _buildActionBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 26,
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const MyProfilePage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              _userController.user!.profileImage,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const CustomShimmer(
                                  width: 36,
                                  height: 36,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const MyProfilePage(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                _userController.user!.profileImage,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const CustomShimmer(
                                    width: 36,
                                    height: 36,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: RichText(
                        text: TextSpan(
                            text: 'liked_by'.tr(),
                            style: textTheme(context).bodySmall,
                            children: [
                          TextSpan(
                            text: 'Furry',
                            style: textTheme(context).bodyMedium,
                          ),
                          TextSpan(text: 'and_others'.tr())
                        ])),
                  ),
                  Text(
                    'recipe_name'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: colorScheme(context).outline),
                  ),
                  Text(
                    'From ${widget.post.name}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: colorScheme(context).outline),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'recipe_category'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: colorScheme(context).outline),
                  ),
                  Text(
                    widget.post.category,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: colorScheme(context).outline),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'preparation_steps'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: colorScheme(context).outline),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: ExpandableTextWidget(
                      fullText: widget.post.preparationSteps,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaggeredImages() {
    final imageUrls = widget.post.images;
    final double width = MediaQuery.sizeOf(context).width;

    if (imageUrls.length == 1) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(imageUrls[0]),
        child: Image.network(
          imageUrls.first,
          height: 350,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const CustomShimmer(
              height: 350,
            );
          },
          errorBuilder: (context, object, stackTrace) =>
              const Center(child: Icon(Icons.error)),
        ),
      );
    } else if (imageUrls.length == 2) {
      return GestureDetector(
        child: Row(
          children: imageUrls.map((imageUrl) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 350,
                  child: GestureDetector(
                    onTap: () => _showFullScreenImage(imageUrl),
                    child: Image.network(
                      imageUrl,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const CustomShimmer(
                          height: 350,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (imageUrls.length == 3) {
      return SizedBox(
          height: 350,
          width: width,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(imageUrls.first),
                        child: Image.network(
                          imageUrls.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const CustomShimmer(
                              height: 350,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: double.infinity,
                            height: 350,
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(imageUrls[1]),
                        child: Image.network(
                          imageUrls[1],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const CustomShimmer(
                              height: 350,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: double.infinity,
                            height: 350,
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(imageUrls.last),
                  child: Image.network(
                    imageUrls.last,
                    height: 350,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CustomShimmer(
                        height: 350,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    } else if (imageUrls.length > 3) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(imageUrls[index]),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CustomShimmer(
                      height: 350,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: imageUrls.length,
              effect: ScrollingDotsEffect(
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: AppColor.hintText,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 6,
              ),
            ),
          ),
        ],
      );
    }

    return Container();
  }

  void _showFullScreenImage(String imageUrl) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: FullScreenImageViewer(imageUrl: imageUrl),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _recipeController.toggleLike(
                    context: context,
                    postId: widget.post.id,
                    onSuccess: (_) {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    onError: (error) {
                      showSnackbar(message: error, isError: true);
                    },
                  );
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                  (widget.post.likes.length + (isFavorite ? 1 : 0)).toString()),
              const SizedBox(width: 17),
              GestureDetector(
                onTap: () {
                  showCommentsModal(context);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.commentIcon),
                    const SizedBox(width: 5),
                    Text('${widget.post.comments.length}'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Share.share(widget.post.name);
                },
                child: SvgPicture.asset(AppIcons.sendIcon),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _recipeController.toggleSave(
                context: context,
                postId: widget.post.id,
                onSuccess: (_) {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                onError: (error) {
                  showSnackbar(message: error, isError: true);
                },
              );
            },
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void showCommentsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromViewPadding(
            View.of(context).viewInsets,
            View.of(context).devicePixelRatio,
          ),
          child: CustomComment(
            postUserId: widget.post.userId,
            comments: widget.post.comments,
            profileImage: _userController.user!.profileImage,
            onSendComment: (comment) async {
              var overlay = context.loaderOverlay;
              overlay.show();
              return _recipeController.addComment(
                context: context,
                postId: widget.post.id,
                commentMessage: comment,
                onSuccess: (_) {
                  overlay.hide();
                  widget.post.commentsCount += 1;
                  setState(() {});
                },
                onError: (error) {
                  overlay.hide();
                  showSnackbar(message: error, isError: true);
                },
              );
            },
            onLikeTapped: (int id) {
              _recipeController.toggleLikeComment(
                context: context,
                commentId: id,
                onSuccess: (_) {},
                onError: (error) {
                  showSnackbar(message: error, isError: true);
                },
              );
            },
          ),
        );
      },
    );
  }
}
