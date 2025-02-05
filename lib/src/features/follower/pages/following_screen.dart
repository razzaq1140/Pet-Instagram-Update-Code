import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen(
      {super.key, required Map<String, String> queryParameters});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import '/src/common/constants/app_colors.dart';
// import '/src/common/constants/app_images.dart';
// import '/src/router/routes.dart';

// import '../../common/constants/global_variables.dart';
// import '../../common/utils/shared_preferences_helper.dart';
// import '../../common/widget/custom_button.dart';

// class MyProfilePage extends StatefulWidget {
//   const MyProfilePage({super.key});

//   @override
//   MyProfilePageState createState() => MyProfilePageState();
// }

// class MyProfilePageState extends State<MyProfilePage> {
//   bool isSeller = false; // Track whether the user is a seller or buyer

//   @override
//   void initState() {
//     super.initState();
//     _loadUserType(); // Load the user type (Seller or Buyer)
//   }

//   // Load user type from SharedPreferences
//   Future<void> _loadUserType() async {
//     bool? storedIsSeller = SharedPrefHelper.getBool('isSeller');
//     setState(() {
//       isSeller = storedIsSeller!;
//     });
//   }

//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   OverlayEntry? overlayEntry;

//   void _onPageChanged(int index) {
//     setState(() {
//       _currentPage = index;
//     });
//   }

//   OverlayEntry createOverlayEntry(String imageUrl) {
//     return OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           // Lightened dark background
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: () {
//                 overlayEntry?.remove();
//                 overlayEntry = null;
//               },
//               child: Container(
//                 color: Colors.black
//                     .withOpacity(0.4), // Reduced opacity for lighter background
//               ),
//             ),
//           ),
//           // Centered image with padding from horizontal edges
//           Center(
//             child: Material(
//               color: Colors.transparent,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20), // Padding for space on both sides
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(8.0),
//                             topRight: Radius.circular(8.0),
//                           ),
//                         ),
//                         tileColor: colorScheme(context).surface,
//                         leading: CircleAvatar(
//                           backgroundImage: AssetImage(AppImages.pinkDog),
//                         ),
//                         title: const Text("Furry Pets"),
//                       ),
//                       CachedNetworkImage(
//                         imageUrl: imageUrl,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(8.0),
//                             bottomRight: Radius.circular(8.0),
//                           ),
//                           color: colorScheme(context).surface,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Icon(
//                               Icons.favorite_border,
//                               color: colorScheme(context).onSurface,
//                             ),
//                             const Icon(Icons.account_circle_outlined),
//                             SvgPicture.asset(AppIcons.sendIcon),
//                             const Icon(Icons.more_vert),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         context.pushNamed(AppRoute.searchScreen);
//                       },
//                       child: SvgPicture.asset(AppIcons.outlineSearch)),
//                   const SizedBox(width: 15),
//                   GestureDetector(
//                       onTap: () {
//                         context.pushNamed(AppRoute.setting);
//                       },
//                       child: SvgPicture.asset(
//                         AppIcons.menuIcon,
//                         width: 15,
//                         height: 15,
//                       )),
//                   const SizedBox(width: 15),
//                   GestureDetector(
//                       onTap: () {
//                         context.pushNamed(AppRoute.notificationPage);
//                       },
//                       child: SvgPicture.asset(AppIcons.notiIcon)),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   // Testing with AssetImage to ensure no network delays are causing the freeze
//                   Flexible(
//                     flex: 1,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage(
//                         AppImages.pinkGirl,
//                         //   'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Flexible(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 const Text(
//                                   '25',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Text('post'.tr()),
//                               ],
//                             ),
//                             // const SizedBox(width: 40),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     context.pushNamed(AppRoute.followerScreen);
//                                   },
//                                   child: const Text(
//                                     '443',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Text('follower'.tr()),
//                               ],
//                             ),
//                             // const SizedBox(width: 40),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     context.pushNamed(AppRoute.followerScreen);
//                                   },
//                                   child: const Text(
//                                     '2,029',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Text('following'.tr()),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         CustomButton(
//                           width: 240,
//                           onTap: () {
//                             context.pushNamed(AppRoute.accountPage);
//                           },
//                           text: 'edit_profile'.tr(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Whiskers Pet',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Lorem Ipsum has been the industry standard dummy text ever since...',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w500,
//                     color: colorScheme(context).outline.withOpacity(0.7)),
//               ),
//               const SizedBox(height: 16),
//               // Conditionally render the Seller Center container
//               if (isSeller) ...[
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 7),
//                   decoration: BoxDecoration(
//                     color: colorScheme(context).onPrimary,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: AppColor.hintText,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Seller Center',
//                           style: textTheme(context).titleMedium,
//                         ),
//                         Text(
//                           'Tools and resources just for businesses.',
//                           style: textTheme(context).bodyLarge,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 16),

//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildStoryAvatar(context, AppImages.pinkCat),
//                     _buildStoryAvatar(context, AppImages.whiteDog),
//                     _buildStoryAvatar(context, AppImages.pinkDog),
//                     _buildStoryAvatar(context, AppImages.whiteDog),
//                     _buildStoryAvatar(context, AppImages.pinkDog),
//                     _buildStoryAvatar(context, AppImages.whiteDog),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Icons for PageView navigation
//               Container(
//                 decoration: BoxDecoration(
//                   color: colorScheme(context).onPrimary,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: AppColor.hintText,
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _pageController
//                           .jumpToPage(0), // Jump to grid view page
//                       child: Icon(
//                         Icons.grid_on,
//                         size: 30,
//                         color: _currentPage == 0
//                             ? colorScheme(context).primary
//                             : colorScheme(context).onSurface,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => _pageController.jumpToPage(1),
//                       child: Icon(
//                         Icons.video_library,
//                         size: 30,
//                         color: _currentPage == 1
//                             ? colorScheme(context).primary
//                             : colorScheme(context).onSurface,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => _pageController
//                           .jumpToPage(2), // Jump to portrait page
//                       child: Icon(
//                         Icons.portrait,
//                         size: 30,
//                         color: _currentPage == 2
//                             ? colorScheme(context).primary
//                             : colorScheme(context).onSurface,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   onPageChanged: _onPageChanged,
//                   children: [
//                     _buildGridView(context),
//                     _buildVideoView(context),
//                     _buildPortraitView(context),
//                   ],
//                 ),
//               ),
//             ],
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
//           GestureDetector(
//             onTap: () {
//               context.pushNamed(AppRoute.statusStory);
//             },
//             child: CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage(image),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build the grid view (page 0)
//   Widget _buildGridView(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.only(top: 8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//       ),
//       itemCount: 12,
//       itemBuilder: (context, index) {
//         return _buildGridItem(
//           context,
//           'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg',
//         );
//       },
//     );
//   }

//   // Build the video view (page 1) - placeholder for now
//   Widget _buildVideoView(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.only(top: 8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//       ),
//       itemCount: 16,
//       itemBuilder: (context, index) {
//         return _buildGridItem(
//           context,
//           'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg',
//         );
//       },
//     );
//   }

//   Widget _buildPortraitView(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.only(top: 8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//       ),
//       itemCount: 12,
//       itemBuilder: (context, index) {
//         return _buildGridItem(
//           context,
//           'https://img.freepik.com/free-photo/view-cats-dogs-being-friends_23-2151806375.jpg',
//         );
//       },
//     );
//   }

//   // Helper method to build a grid item
//   Widget _buildGridItem(BuildContext context, String imageUrl) {
//     return GestureDetector(
//       onLongPressStart: (details) {
//         // Close any previous overlay before showing a new one
//         if (overlayEntry != null) {
//           overlayEntry?.remove();
//           overlayEntry = null;
//         }

//         // Show overlay on long press start
//         overlayEntry = createOverlayEntry(imageUrl);
//         Overlay.of(context).insert(overlayEntry!);
//       },
//       onLongPressEnd: (details) {
//         // Remove overlay on long press end
//         overlayEntry?.remove();
//         overlayEntry = null;
//       },
//       onTap: () {
//         context.pushNamed(
//           AppRoute.postPage,
//           queryParameters: {
//             'imageUrl': imageUrl, // This passes the image URL
//           },
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
