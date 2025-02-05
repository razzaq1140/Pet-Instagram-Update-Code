import 'dart:io';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/home/controller/home_controller.dart';
import '/src/features/home/controller/home_story_controller.dart';
import '/src/features/home/pages/add_post_page.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/features/search/search_page.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../router/routes.dart';
import '../widget/post_home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late HomeController _homeController;
  late HomeStoryController _homeStoryController;
  @override
  void initState() {
    _homeController = Provider.of<HomeController>(context, listen: false);
    _homeStoryController =
        Provider.of<HomeStoryController>(context, listen: false);
    _homeController.homePostScrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _homeController.homePostScrollController
          .addListener(_homeController.scrollListener);
      _homeController.toggleLoading();
      await Future.wait([
        _homeStoryController.fetchOwnStory(),
        _homeController.fetchPostFeed(),
        _homeStoryController.fetchFollowersStory(),
      ]);
      _homeController.toggleLoading();
      log('${await FirebaseMessaging.instance.getToken()}');
    });
  }

  Future<void> _pullRefresh() async {
    _homeController.toggleLoading();
    _homeController.clearAll();
    _homeStoryController.clearAll();
    await Future.wait([
      _homeStoryController.fetchOwnStory(),
      _homeController.fetchPostFeed(),
      _homeStoryController.fetchFollowersStory(),
    ]);
    _homeController.toggleLoading();
  }

  // Function to handle adding a story (Picking an image or video)
  Future<void> _addStory() async {
    await _homeStoryController.pickImage(context, () {
      if (mounted) {
        context.pushNamed(AppRoute.addStoryPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // You can return a Future here to handle the pop behavior.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );

        // Return true to allow the pop, false to prevent it.
        // return shouldPop;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: SingleChildScrollView(
              controller: _homeController.homePostScrollController,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'home'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      color: colorScheme(context).onSurface),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: AddPostPage(),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              },
                              child: Icon(
                                Icons.add,
                                color: colorScheme(context)
                                    .outline
                                    .withOpacity(0.4),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 5),
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
                              child: SvgPicture.asset(
                                AppIcons.outlineSearch,
                              ),
                            ),
                            const SizedBox(width: 5),
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
                                child: SvgPicture.asset(AppIcons.notiIcon)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            // First item as your profile story

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // _viewStory(index);

                                      if (_homeStoryController
                                          .isMyStoryAvailable) {
                                        context.pushNamed(
                                          AppRoute.storyPage,
                                          extra: {
                                            'index': 0,
                                            'stories': _homeStoryController
                                                .followersStories,
                                          },
                                        );
                                      } else {
                                        _addStory();
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Consumer2<UserController,
                                                HomeStoryController>(
                                            builder: (context, userController,
                                                homeStoryController, widget) {
                                          if (homeStoryController
                                              .isStoryLoading) {
                                            return const CustomShimmer(
                                              height: 70,
                                              width: 70,
                                              radius: 70,
                                            );
                                          }
                                          return CircleAvatar(
                                            radius: 35,
                                            child: ClipOval(
                                              child: Image(
                                                height: 70,
                                                width: 70,
                                                image: NetworkImage(
                                                    userController
                                                        .user!.profileImage),
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const CustomShimmer(
                                                    height: 70,
                                                    width: 70,
                                                    radius: 70,
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  height: 70,
                                                  width: 70,
                                                  fit: BoxFit.cover,
                                                  'assets/images/splashdog.png',
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        GestureDetector(
                                          onTap: _addStory,
                                          child: Container(
                                            height: 25,
                                            width: 26,
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'your_story'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color:
                                                colorScheme(context).onSurface),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Consumer<HomeStoryController>(builder:
                                  (context, homeStoryController, widget) {
                                if (homeStoryController
                                    .isFollowerStoryLoading) {
                                  return SizedBox(
                                    height: 60,
                                    child: ListView.separated(
                                      itemCount: 5,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 8,
                                      ),
                                      itemBuilder: (context, index) =>
                                          const CustomShimmer(
                                        height: 60,
                                        width: 60,
                                        radius: 60,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    itemCount:
                                        homeStoryController.isMyStoryAvailable
                                            ? homeStoryController
                                                    .followersStories.length -
                                                1
                                            : homeStoryController
                                                .followersStories.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 8,
                                    ),
                                    itemBuilder: (context, index) {
                                      log(index.toString());
                                      log(homeStoryController
                                          .followersStories.length
                                          .toString());
                                      int updatedIndex =
                                          homeStoryController.isMyStoryAvailable
                                              ? index + 1
                                              : index;

                                      log('list update$updatedIndex');
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              log('list ontap$updatedIndex');
                                              context.pushNamed(
                                                AppRoute.storyPage,
                                                extra: {
                                                  'index': updatedIndex,
                                                  'stories':
                                                      _homeStoryController
                                                          .followersStories,
                                                },
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(
                                                child: Image(
                                                  height: 60,
                                                  width: 60,
                                                  image: NetworkImage(
                                                      homeStoryController
                                                          .followersStories[
                                                              updatedIndex]
                                                          .user
                                                          .profileImage),
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const CustomShimmer(
                                                      height: 70,
                                                      width: 70,
                                                      radius: 70,
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                    'assets/images/splashdog.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              homeStoryController
                                                  .followersStories[index]
                                                  .user
                                                  .name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                      color:
                                                          colorScheme(context)
                                                              .onSurface),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      // Posts Section
                      Consumer<HomeController>(
                        builder: (context, homeController, widget) {
                          if (homeController.isLoading) {
                            return Column(
                              children: List.generate(4, (index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: CustomShimmer(
                                    height: 400,
                                  ),
                                );
                              }),
                            );
                          }
                          if (homeController.postList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text('No Posts Found'),
                                    ElevatedButton(
                                      onPressed: _pullRefresh,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              colorScheme(context).primary),
                                      child: Text(
                                        'Refresh',
                                        style: textTheme(context)
                                            .bodyMedium
                                            ?.copyWith(
                                              color: colorScheme(context)
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: homeController.postList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (homeController.currentPage <
                                  homeController.totalPage) {
                                return Column(
                                  children: [
                                    PostHomeWidget(
                                        post: homeController.postList[index]),
                                    if (index ==
                                        homeController.postList.length - 1)
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 40),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                            Text('Loading ...')
                                          ],
                                        ),
                                      )
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  PostHomeWidget(
                                      post: homeController.postList[index]),
                                  if (index ==
                                      homeController.postList.length - 1)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 40),
                                      child: Center(
                                          child: Text('No More Posts Found')),
                                    )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
