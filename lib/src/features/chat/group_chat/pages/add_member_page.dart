import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/extensions.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/chat/group_chat/controller/group_messages_controller.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../follower/models/follower_model.dart';

class AddRemoveMemberPage extends StatefulWidget {
  const AddRemoveMemberPage({super.key});

  @override
  AddRemoveMemberPageState createState() => AddRemoveMemberPageState();
}

class AddRemoveMemberPageState extends State<AddRemoveMemberPage> {
  late GroupMessagesController _groupMessageController;
  late UserController _userController;

  @override
  void initState() {
    _groupMessageController =
        Provider.of<GroupMessagesController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groupMessageController.fetchFollowersAndFollowing(
          userId: _userController.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
      ),
      body: Consumer2<GroupMessagesController, UserController>(
        builder: (context, messageController, userController, widget) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Adjust the height based on content
              children: [
                // Search Input Field
                Text(
                  'Add Members',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16, color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hint: 'search_hint'.tr(),
                  borderColor: colorScheme(context).outline.withOpacity(0.4),
                  fillColor: colorScheme(context).surface,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(AppIcons.filter),
                  ),
                  suffixConstraints: const BoxConstraints(minHeight: 20),
                  onChanged: messageController.filterList,
                ),
                const SizedBox(height: 16),

                // Member selection header
                Text(
                  'select_members'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16, color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 16),

                // Members List with Cached Network Image and Checkbox
                Expanded(
                  child: ListView.builder(
                    itemCount: messageController.isLoadingFollwers
                        ? 10
                        : messageController.filteredFollowerList.length,
                    itemBuilder: (context, index) {
                      if (messageController.isLoadingFollwers) {
                        return const ListTile(
                          leading: CustomShimmer(
                            height: 50,
                            width: 50,
                            radius: 35,
                          ),
                          title: CustomShimmer(
                            height: 10,
                          ),
                          subtitle: CustomShimmer(
                            height: 10,
                          ),
                        );
                      }
                      final FollowerModel follower =
                          messageController.filteredFollowerList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Add space between items
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // Remove default padding
                          leading: CachedNetworkImage(
                            imageUrl: follower.profileImage,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 25,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CustomShimmer(
                              height: 50,
                              width: 50,
                              radius: 35,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(
                            follower.username.initCapitalized,
                            style: textTheme(context).titleSmall,
                          ),
                          trailing: messageController.memberList.any(
                                  (member) => member.userId == follower.userId)
                              ? Text('Member')
                              : Checkbox(
                                  value: messageController.selectedFollowers
                                      .contains(follower.userId),
                                  onChanged: (bool? value) {
                                    messageController
                                        .addMember(follower.userId);
                                  },
                                ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Confirm Button
                CustomButton(
                  height: 45,
                  onTap: () async {
                    var overlay = context.loaderOverlay;
                    if (messageController.selectedFollowers.isNotEmpty) {
                      overlay.show();
                      await messageController.addGroupMembers(
                        groupId: messageController.currentGroup!.id,
                        members: messageController.selectedFollowers,
                      );
                      overlay.hide();
                    }
                    if (context.mounted) {
                      PersistentNavBarNavigator.pop(context);
                    }
                  },
                  text: 'confirm'.tr(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
