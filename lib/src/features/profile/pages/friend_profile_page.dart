// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '/src/common/constants/app_images.dart';
// import '/src/features/follower/controller/followers_controller.dart';
// import '/src/features/profile/controller/other_profile_controller.dart';
// import '/src/router/routes.dart';
// import 'package:provider/provider.dart';
// import '../../../common/constants/global_variables.dart';
// import '../../../common/widget/custom_button.dart';

// class FriendProfilePage extends StatefulWidget {
//   const FriendProfilePage({super.key, required this.userId});
//   final int? userId;

//   @override
//   State<FriendProfilePage> createState() => _FriendProfilePageState();
// }

// class _FriendProfilePageState extends State<FriendProfilePage> {
//   @override
//   void initState() {
//     super.initState();

//     final controller =
//         Provider.of<OtherProfileController>(context, listen: false);

//     final followersController =
//         Provider.of<FollowersController>(context, listen: false);
//     followersController.loadFollowStatus(widget.userId!);

//     Timer(
//       const Duration(seconds: 1),
//       () {
//         controller.fetchSingleUser(userId: widget.userId!);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Consumer<OtherProfileController>(
//               builder: (context, controller, child) => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // CircleAvatar(
//                       //   radius: 50,
//                       //   backgroundImage: CachedNetworkImageProvider(
//                       //     controller.otherUserProfile?.profileImage ?? '',
//                       //     errorListener: (p0) {},
//                       //   ),
//                       //   onBackgroundImageError: (_, __) =>
//                       //       AssetImage(AppImages.splashdogds),
//                       // ),
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage:
//                             controller.otherUserProfile?.profileImage != null &&
//                                     controller.otherUserProfile!.profileImage!
//                                         .isNotEmpty
//                                 ? NetworkImage(
//                                     controller.otherUserProfile!.profileImage!)
//                                 : AssetImage(AppImages.splashdogds),
//                       ),
//                       const SizedBox(width: 6),
//                       SizedBox(
//                         width: 220,
//                         // color: Colors.blue,
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text(
//                                       controller.otherUserProfile?.postsCount
//                                               .toString() ??
//                                           '0',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const Text('Post'),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 30),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       controller
//                                               .otherUserProfile?.followersCount
//                                               .toString() ??
//                                           '0',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const Text(
//                                       'Followers',
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 30),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       controller
//                                               .otherUserProfile?.followingCount
//                                               .toString() ??
//                                           '0',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const Text('Following'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             Consumer<FollowersController>(
//                               builder: (context, value, child) => CustomButton(
//                                 width: 220,
//                                 onTap: () {
//                                   //!
//                                   value.sendFollowAndSendRequest(
//                                       userId: widget.userId!);
//                                   // if (value.followStatus == 1) {
//                                   //   context.pushNamed(AppRoute.profileMessage);
//                                   // }
//                                 },
//                                 text: value.getFollowButtonText(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     controller.otherUserProfile?.username.toString() ?? '',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     controller.otherUserProfile?.about.toString() ?? '',
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: colorScheme(context).outline.withOpacity(0.7)),
//                   ),
//                   const SizedBox(height: 16),

//                   // Highlighted Stories (horizontal scrolling list)
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         _buildStoryAvatar(context, AppImages.pinkCat),
//                         _buildStoryAvatar(context, AppImages.whiteDog),
//                         _buildStoryAvatar(context, AppImages.pinkDog),
//                         _buildStoryAvatar(context, AppImages.whiteDog),
//                         _buildStoryAvatar(context, AppImages.pinkDog),
//                         _buildStoryAvatar(context, AppImages.whiteDog),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.grey.withOpacity(0.4),
//                       ),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               context.pushNamed(AppRoute.feedPage);
//                             },
//                             child: const Icon(Icons.grid_on,
//                                 size: 30, color: Colors.black54)),
//                         const Icon(Icons.video_library,
//                             size: 30, color: Colors.black54),
//                         const Icon(Icons.portrait,
//                             size: 30, color: Colors.black54),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // GridView.builder removed for debugging.
//                   // Temporarily comment out to isolate if it’s causing the freeze
//                   // Uncomment if you find the rest works fine

//                   GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       mainAxisSpacing: 4,
//                       crossAxisSpacing: 4,
//                     ),
//                     itemCount: 9, // Number of items in the grid
//                     itemBuilder: (context, index) {
//                       return _buildGridItem(context,
//                           'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build a story avatar
//   Widget _buildStoryAvatar(BuildContext context, String image) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: AssetImage(image), // AssetImage for local images
//           ),
//         ],
//       ),
//     );
//   }

// //  Helper method to build a grid item (commented out for debugging)
//   Widget _buildGridItem(BuildContext context, String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/features/follower/controller/followers_controller.dart';
import '/src/features/profile/controller/other_profile_controller.dart';
import '/src/features/profile/pages/post.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_button.dart';
import '../../chat/individual_chat/models/chat_room_model.dart';
import '../../follower/pages/follower_screen.dart';

class FriendProfilePage extends StatefulWidget {
  const FriendProfilePage({super.key, required this.userId});
  final int? userId;

  @override
  FriendProfilePageState createState() => FriendProfilePageState();
}

class FriendProfilePageState extends State<FriendProfilePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  OverlayEntry? overlayEntry;
  late OtherProfileController otherProfileController;
  late FollowersController followersController;
  bool showMessageButton = false;
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

    otherProfileController =
        Provider.of<OtherProfileController>(context, listen: false);

    followersController =
        Provider.of<FollowersController>(context, listen: false);

    followersController.loadFollowStatus(widget.userId!);

    Timer(
      const Duration(seconds: 1),
      () {
        otherProfileController.fetchSingleUser(userId: widget.userId!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Consumer<OtherProfileController>(
                      builder: (context, otherProfileController, child) =>
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              onSelected: (value) {
                                switch (value) {
                                  case 'message':
                                    context.pushNamed(
                                      AppRoute.messagePage,
                                      extra: ChatRoomOtherUserModel(
                                          id: otherProfileController
                                              .otherUserProfile!.id,
                                          name: otherProfileController
                                              .otherUserProfile!.about!,
                                          profileImage: otherProfileController
                                              .otherUserProfile!.profileImage!,
                                          username: otherProfileController
                                              .otherUserProfile!.username!),
                                    );
                                    break;
                                  case 'report':
                                    break;
                                  default:
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  if (followersController.checkMessagebutton())
                                    const PopupMenuItem(
                                        value: 'message',
                                        child: Text('Message')),
                                  const PopupMenuItem(
                                      value: 'report', child: Text('Report')),
                                ];
                              },
                              child: const Icon(Icons.more_vert_sharp),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: otherProfileController
                                                  .otherUserProfile
                                                  ?.profileImage !=
                                              null &&
                                          otherProfileController
                                              .otherUserProfile!
                                              .profileImage!
                                              .isNotEmpty
                                      ? NetworkImage(otherProfileController
                                          .otherUserProfile!.profileImage!)
                                      : AssetImage(AppImages.splashdogds),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              (otherProfileController
                                                          .otherUserProfile !=
                                                      null)
                                                  ? otherProfileController
                                                      .otherUserProfile!
                                                      .postsCount
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
                                              screen: PetFollowerScreen(
                                                userId: widget.userId,
                                                queryParameters: const {
                                                  'tabIndex': '0'
                                                },
                                              ),
                                              withNavBar: true,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation.fade,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                (otherProfileController
                                                            .otherUserProfile !=
                                                        null)
                                                    ? otherProfileController
                                                        .otherUserProfile!
                                                        .followersCount
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
                                                  screen: PetFollowerScreen(
                                                    userId: widget.userId,
                                                    queryParameters: const {
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
                                                (otherProfileController
                                                            .otherUserProfile !=
                                                        null)
                                                    ? otherProfileController
                                                        .otherUserProfile!
                                                        .followingCount
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
                                    Consumer<FollowersController>(
                                      builder: (context, value, child) =>
                                          CustomButton(
                                        width: 240,
                                        onTap: () {
                                          value.sendFollowAndSendRequest(
                                              userId: widget.userId!);
                                        },
                                        text: value.getFollowButtonText(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  (otherProfileController.otherUserProfile !=
                                          null)
                                      ? otherProfileController
                                          .otherUserProfile!.username
                                          .toString()
                                      : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              (otherProfileController.otherUserProfile != null)
                                  ? otherProfileController
                                      .otherUserProfile!.about
                                      .toString()
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                        onTap: () => _pageController.jumpToPage(2),
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
                  child: PageView(
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
