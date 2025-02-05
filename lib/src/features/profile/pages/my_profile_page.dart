// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pet_project/src/features/profile/controller/profile_controller.dart';
import '../widgets/expandable_page_view.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/features/profile/pages/post.dart';
import '/src/features/settings/controller/settings_controller.dart';
import '/src/features/search/search_page.dart';
import '/src/features/settings/pages/setting_page.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import '../../_user_data/controllers/user_controller.dart';
import '../../../common/widget/custom_button.dart';
import '../../follower/pages/follower_screen.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  bool isSeller = false;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  OverlayEntry? overlayEntry;
  late SettingsController settingsController;
  late UserController _userController;
  late ProfileController _profileController;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  OverlayEntry createOverlayEntry(String imageUrl) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                overlayEntry?.remove();
                overlayEntry = null;
              },
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        tileColor: colorScheme(context).surface,
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(AppImages.pinkDog),
                        ),
                        title: const Text("Furry Pets"),
                      ),
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          color: colorScheme(context).surface,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: colorScheme(context).onSurface,
                            ),
                            const Icon(Icons.account_circle_outlined),
                            SvgPicture.asset(AppIcons.sendIcon),
                            const Icon(Icons.more_vert),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    settingsController =
        Provider.of<SettingsController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    _profileController = Provider.of<ProfileController>(context, listen: false);

    isSeller = settingsController.isSeller;
    _profileController.fetchPostFeed();
  }

  Future<void> _pullRefresh() async {
    _userController.fetchUserData();
    _profileController.fetchPostFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                Consumer<UserController>(
                    builder: (context, userController, widget) {
                  return SliverAppBar(
                    pinned: true,
                    expandedHeight: isSeller ? 380.0 : 300.0,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const SearchPage(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: SvgPicture.asset(AppIcons.outlineSearch),
                      ),
                      const SizedBox(width: 15),
                      Consumer<SettingsController>(
                        builder: (context, value, child) => GestureDetector(
                          onTap: () async {
                            await value.fetchCurrentUser();
                            log("Navigating to settings with current role: ${value.currentRole}");
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const SettingPage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: SvgPicture.asset(
                            AppIcons.personIcon,
                            width: 19,
                            height: 19,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const NotificationPage(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: SvgPicture.asset(AppIcons.notiIcon),
                      ),
                      const SizedBox(width: 15),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      // title: Row(
                      //   children: [
                      //     ClipOval(
                      //       child: Image.network(
                      //         userController.user!.profileImage,
                      //         height: 40,
                      //         width: 40,
                      //         fit: BoxFit.cover,
                      //         loadingBuilder:
                      //             (context, child, loadingProgress) {
                      //           if (loadingProgress == null) {
                      //             return child;
                      //           }
                      //           return Center(
                      //             child: CircularProgressIndicator(
                      //               color: colorScheme(context).surface,
                      //             ),
                      //           );
                      //         },
                      //         errorBuilder: (context, error, stackTrace) {
                      //           return Image.asset(
                      //             height: 100,
                      //             width: 100,
                      //             fit: BoxFit.cover,
                      //             'assets/images/splashdog.png',
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      background: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                      child: Image.network(
                                        userController.user!.profileImage,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  colorScheme(context).surface,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            'assets/images/splashdog.png',
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                (userController.user != null)
                                                    ? userController
                                                        .user!.postsCount
                                                        .toString()
                                                    : '0',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text('post'.tr()),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreen(
                                                context,
                                                screen: const PetFollowerScreen(
                                                  userId: 1,
                                                  queryParameters: {
                                                    'tabIndex': '0'
                                                  },
                                                ),
                                                withNavBar: true,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .fade,
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  (userController.user != null)
                                                      ? userController
                                                          .user!.followersCount
                                                          .toString()
                                                      : '0',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text('follower'.tr()),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  PersistentNavBarNavigator
                                                      .pushNewScreen(
                                                    context,
                                                    screen:
                                                        const PetFollowerScreen(
                                                      userId: 1,
                                                      queryParameters: {
                                                        'tabIndex': '1'
                                                      },
                                                    ),
                                                    withNavBar: true,
                                                    pageTransitionAnimation:
                                                        PageTransitionAnimation
                                                            .fade,
                                                  );
                                                },
                                                child: Text(
                                                  (userController.user != null)
                                                      ? userController
                                                          .user!.followingCount
                                                          .toString()
                                                      : '0',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Text('following'.tr()),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      CustomButton(
                                        width: 240,
                                        onTap: () {
                                          context
                                              .pushNamed(AppRoute.accountPage);
                                        },
                                        text: 'edit_profile'.tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              (userController.user != null)
                                  ? userController.user!.name.toString()
                                  : '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                (userController.user != null)
                                    ? userController.user!.about
                                    : '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme(context)
                                            .outline
                                            .withOpacity(0.7)),
                                overflow: TextOverflow.clip,
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Conditionally render the Seller Center container
                            if (isSeller) ...[
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: colorScheme(context).onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColor.hintText,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Seller Center',
                                        style: textTheme(context).titleMedium,
                                      ),
                                      Text(
                                        'Tools and resources just for businesses.',
                                        style: textTheme(context).bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                })
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStoryAvatar(context, AppImages.pinkCat),
                        _buildStoryAvatar(context, AppImages.whiteDog),
                        _buildStoryAvatar(context, AppImages.pinkDog),
                        _buildStoryAvatar(context, AppImages.whiteDog),
                        _buildStoryAvatar(context, AppImages.pinkDog),
                        _buildStoryAvatar(context, AppImages.whiteDog),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Icons for PageView navigation
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme(context).onPrimary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.hintText,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => _pageController
                              .jumpToPage(0), // Jump to grid view page
                          child: Icon(
                            Icons.grid_on,
                            size: 30,
                            color: _currentPage == 0
                                ? colorScheme(context).primary
                                : colorScheme(context).onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pageController.jumpToPage(1),
                          child: Icon(
                            Icons.video_library,
                            size: 30,
                            color: _currentPage == 1
                                ? colorScheme(context).primary
                                : colorScheme(context).onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pageController
                              .jumpToPage(2), // Jump to portrait page
                          child: Icon(
                            Icons.portrait,
                            size: 30,
                            color: _currentPage == 2
                                ? colorScheme(context).primary
                                : colorScheme(context).onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ExpandablePageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        _buildGridView(context),
                        _buildVideoView(context),
                        _buildPortraitView(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a story avatar
  Widget _buildStoryAvatar(BuildContext context, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoute.statusStory);
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
            ),
          ),
        ],
      ),
    );
  }

  // Build the grid view (page 0)
  Widget _buildGridView(BuildContext context) {
    return Consumer<ProfileController>(
        builder: (context, profileController, widget) {
      return GridView.builder(
        shrinkWrap: true,
        // physics:
        //     const NeverScrollableScrollPhysics(), // Prevent internal scrolling
        padding: const EdgeInsets.only(top: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: profileController.postList.length,
        itemBuilder: (context, index) {
          if (profileController.postList[index].mediaPaths.isEmpty) {
            return null;
          }
          return _buildGridItem(
            context,
            profileController.postList[index].mediaPaths.first,
          );
        },
      );
    });
  }

  // Build the video view (page 1) - placeholder for now
  Widget _buildVideoView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Prevent internal scrolling
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        return _buildGridItem(
          context,
          'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg',
        );
      },
    );
  }

  Widget _buildPortraitView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Prevent internal scrolling
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return _buildGridItem(
          context,
          'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg',
        );
      },
    );
  }

  // Helper method to build a grid item
  Widget _buildGridItem(BuildContext context, String imageUrl) {
    return GestureDetector(
      onLongPressStart: (details) {
        // Close any previous overlay before showing a new one
        if (overlayEntry != null) {
          overlayEntry?.remove();
          overlayEntry = null;
        }

        // Show overlay on long press start
        overlayEntry = createOverlayEntry(imageUrl);
        Overlay.of(context).insert(overlayEntry!);
      },
      onLongPressEnd: (details) {
        // Remove overlay on long press end
        overlayEntry?.remove();
        overlayEntry = null;
      },
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: PostsPage(
            queryParameters: {
              'imageUrl': imageUrl,
            },
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
