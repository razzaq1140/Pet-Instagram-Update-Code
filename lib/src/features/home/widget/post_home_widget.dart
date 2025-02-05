import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/widget/custom_comments.dart';
import '/src/features/home/controller/home_controller.dart';
import '/src/features/home/widget/show_full_screen_image.dart'; // Ensure you have this import for the FullScreenImageViewer
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../common/constants/app_colors.dart';
import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/utils/custom_snackbar.dart';
import '../../../common/widget/custom_shimmer.dart';
import '../../_user_data/controllers/user_controller.dart';
import '../../profile/pages/friend_profile_page.dart';
import '../../profile/pages/my_profile_page.dart';
import '../model/post_model.dart';

class PostHomeWidget extends StatefulWidget {
  final PostModel post;

  const PostHomeWidget({
    super.key,
    required this.post,
  });

  @override
  State<PostHomeWidget> createState() => _PostHomeWidgetState();
}

class _PostHomeWidgetState extends State<PostHomeWidget> {
  bool isFavorite = false;
  bool isBookmarked = false;
  final PageController _pageController = PageController();
  int currentIndex = 0;
  late HomeController _homeController;
  late UserController _userController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController = Provider.of<HomeController>(context, listen: false);
      _userController = Provider.of<UserController>(context, listen: false);
      isFavorite = widget.post.likedByUser;
      isBookmarked = widget.post.savedByUser;
      setState(() {});
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

  String changeToStandardDate(DateTime date) {
    return DateFormat('MMM dd,yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  if (_userController.user!.id == widget.post.user.id) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const MyProfilePage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: FriendProfilePage(
                        userId: widget.post.user.id,
                      ),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }
                },
                child: ClipOval(
                    child: Image.network(
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  widget.post.user.profileImage,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const CustomShimmer(
                      width: 40,
                      height: 40,
                      radius: 20,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      AppImages.pinkDog,
                    );
                  },
                )),
              ),
              title: GestureDetector(
                onTap: () {
                  if (_userController.user!.id == widget.post.user.id) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const MyProfilePage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: FriendProfilePage(
                        userId: widget.post.user.id,
                      ),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.user.name.isEmpty
                          ? widget.post.user.username
                          : widget.post.user.name,
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
                          if (_userController.user!.id == widget.post.user.id) {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const MyProfilePage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          } else {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: FriendProfilePage(
                                userId: widget.post.user.id,
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            widget.post.user.profileImage,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const CustomShimmer(
                                width: 36,
                                height: 36,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              );
                            },
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
                            if (_userController.user!.id ==
                                widget.post.user.id) {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const MyProfilePage(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            } else {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: FriendProfilePage(
                                  userId: widget.post.user.id,
                                ),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              widget.post.user.profileImage,
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
                              errorBuilder: (context, error, stackTrace) {
                                log('${stackTrace}home 3');

                                return const SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  ),
                                );
                              },
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
                  widget.post.caption, // Show description
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                  softWrap: true,
                ),
                Text(
                  changeToStandardDate(widget.post.createdAt),
                  style: const TextStyle(
                    color: AppColor.hintText,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggeredImages() {
    final imageUrls = widget.post.mediaPaths;
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
          errorBuilder: (context, object, stackTrace) {
            log('${stackTrace}home 4');

            return const Center(child: Icon(Icons.error));
          },
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
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: double.infinity,
                          height: 350,
                          child: Center(
                            child: Icon(Icons.error),
                          ),
                        );
                      },
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
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: double.infinity,
                              height: 350,
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            );
                          },
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
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: double.infinity,
                              height: 350,
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            );
                          },
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
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    },
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
                  _homeController.toggleLike(
                    context: context,
                    postId: widget.post.id,
                    onSuccess: (_) {
                      setState(() {
                        if (isFavorite) {
                          widget.post.likedCount -= 1;
                        } else {
                          widget.post.likedCount += 1;
                        }
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
              Text((widget.post.likedCount).toString()),
              const SizedBox(width: 17),
              GestureDetector(
                onTap: () {
                  showCommentsModal(context);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.commentIcon),
                    const SizedBox(width: 5),
                    Text('${widget.post.commentsCount}'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Share.share(widget.post.caption);
                },
                child: SvgPicture.asset(AppIcons.sendIcon),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _homeController.toggleSave(
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
              return _homeController.addComment(
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
              _homeController.toggleLikeComment(
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
