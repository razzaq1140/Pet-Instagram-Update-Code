import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/follower/controller/followers_controller.dart';
import 'package:provider/provider.dart';
import '../../../common/utils/custom_snackbar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () {
        final controller =
            Provider.of<FollowersController>(context, listen: false);

        controller.fetchFollowRequests();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 4,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'notifications'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTab('all'.tr(), 0, width: 100),
                const SizedBox(width: 15),
                _buildTab('follow_request'.tr(), 1, width: 180),
              ],
            ),
          ),
          Divider(color: colorScheme(context).outline.withOpacity(0.1)),
          Expanded(
            child:
                // _selectedTabIndex == 0? _buildNotificationList('following'.tr()) // "All" tab content:

                _buildNotificationListWithButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, {double width = 120}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? colorScheme(context).primary
              : colorScheme(context).onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.hintText),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: _selectedTabIndex == index
                ? colorScheme(context).onPrimary
                : colorScheme(context).onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget _buildNotificationList(String label) {
  //   return ListView.builder(
  //     itemCount: followers.length,
  //     itemBuilder: (context, index) {
  //       final follower = followers[index];
  //       return ListTile(
  //         leading: CircleAvatar(
  //           radius: 25,
  //           backgroundImage: NetworkImage(follower.avatarUrl),
  //         ),
  //         title: Text(
  //           follower.name,
  //           style: Theme.of(context)
  //               .textTheme
  //               .bodyMedium
  //               ?.copyWith(color: colorScheme(context).onSurface),
  //         ),
  //         subtitle: Text(
  //           follower.subtitle,
  //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 color: AppColor.hintText,
  //               ),
  //         ),
  //         trailing: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           decoration: BoxDecoration(
  //             color: colorScheme(context).onPrimary,
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(
  //               color: AppColor.hintText,
  //             ),
  //           ),
  //           child: Text(
  //             label,
  //             style: TextStyle(
  //               color: colorScheme(context).onSurface,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildNotificationListWithButtons() {
    return Consumer<FollowersController>(
      builder: (context, controller, child) {
        if (controller.followRequestList.isEmpty) {
          return Center(
            child: Text(
              'There are no follow requests',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.followRequestList.length,
          itemBuilder: (context, index) {
            final followRequest = controller.followRequestList[index];
            final follower = followRequest.follower;

            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: follower.profileImage != null
                    ? NetworkImage(follower.profileImage!)
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
              title: Text(
                follower.username,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colorScheme(context).onSurface),
              ),
              subtitle: Text(
                'Request ID: ${followRequest.id}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.hintText,
                    ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.followRequestResponse(
                        userId: followRequest.followerId,
                        followRequestResponse: 'accepted',
                      );
                      showSnackbar(message: 'Follow request accepted');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme(context).primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme(context).onPrimary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.followRequestResponse(
                        userId: followRequest.followerId,
                        followRequestResponse: 'rejected',
                      );
                      showSnackbar(message: 'Follow request rejected');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme(context).onSurface,
                      backgroundColor: colorScheme(context).onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme(context).onSurface,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
