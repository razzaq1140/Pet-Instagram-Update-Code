import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/widget/custom_search_delegate.dart';
import '/src/features/profile/controller/other_profile_controller.dart';
import 'package:provider/provider.dart';

import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_text_field.dart';

class PetFollowerScreen extends StatefulWidget {
  const PetFollowerScreen({
    super.key,
    this.queryParameters = const {},
    required this.userId,
  });

  final Map<String, dynamic> queryParameters;
  final int? userId;

  @override
  PetFollowerScreenState createState() => PetFollowerScreenState();
}

class PetFollowerScreenState extends State<PetFollowerScreen> {
  late int currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    currentIndex =
        int.tryParse(widget.queryParameters['tabIndex']?.toString() ?? '0') ??
            0;
    _pageController = PageController(initialPage: currentIndex);

//!
    final controller =
        Provider.of<OtherProfileController>(context, listen: false);

    Timer(
      const Duration(seconds: 1),
      () {
        controller.fetchSingleUserFollowers(userId: widget.userId!);

        controller.fetchSingleUserFollowing(userId: widget.userId!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Pet Follower',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 20, color: colorScheme(context).onSurface),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(
                      searchTerms: ['Dogs', 'Cats', 'Birds', 'Fish', 'Pets'],
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(AppIcons.outlineSearch),
                    ),
                    readOnly: true,
                    hint: 'Search here..',
                    borderColor: colorScheme(context).outline.withOpacity(0.4),
                    fillColor: colorScheme(context).surface,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(AppIcons.filter),
                    ),
                    suffixConstraints: const BoxConstraints(minHeight: 20),
                  ),
                ),
              ),
            ),

            // PageView to display Followers or Following list
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  buildFollowerList('Remove'),
                  buildFollowingList('Following'),
                ],
              ),
            ),

            // Toggle buttons for Followers and Following
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme(context).onPrimary,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: colorScheme(context).outline.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  children: [
                    // Followers Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                          _pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: currentIndex == 0
                                ? colorScheme(context).primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Followers',
                            style: TextStyle(
                              color: currentIndex == 0
                                  ? colorScheme(context).surface
                                  : colorScheme(context)
                                      .outline
                                      .withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Following Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                          _pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: currentIndex == 1
                                ? colorScheme(context).primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Following',
                            style: TextStyle(
                              color: currentIndex == 1
                                  ? colorScheme(context).surface
                                  : colorScheme(context)
                                      .outline
                                      .withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Follower/Following List based on screen (label is passed as a parameter)
  Widget buildFollowerList(String label) {
    return Consumer<OtherProfileController>(
      builder: (context, value, child) => ListView.builder(
        itemCount: value.followers.length,
        itemBuilder: (context, index) {
          final follower = value.followers[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: follower.profileImage != null
                  ? NetworkImage(follower.profileImage!)
                  : AssetImage(AppImages.whiteDog) as ImageProvider,
            ),
            title: Text(
              follower.username,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme(context).onSurface,
                  ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme(context).onPrimary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme(context).onSurface.withOpacity(0.3),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: colorScheme(context).onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildFollowingList(String label) {
  return Consumer<OtherProfileController>(
    builder: (context, value, child) => ListView.builder(
      itemCount: value.followings.length,
      itemBuilder: (context, index) {
        final following = value.followings[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: following.profileImage != null
                ? NetworkImage(following.profileImage!)
                : AssetImage(AppImages.whiteDog) as ImageProvider,
          ),
          title: Text(
            following.username,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme(context).onSurface,
                ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme(context).onPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme(context).onSurface.withOpacity(0.3),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: colorScheme(context).onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
  );
}
