import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/src/common/constants/extensions.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../follower/models/follower_model.dart';
import '../controller/group_chat_controller.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  CreateGroupBottomSheetState createState() => CreateGroupBottomSheetState();
}

class CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  late GroupChatController _groupChatController;
  late UserController _userController;
  @override
  void initState() {
    _groupChatController =
        Provider.of<GroupChatController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groupChatController.fetchFollowersAndFollowing(
          userId: _userController.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer2<GroupChatController, UserController>(
          builder: (context, groupChatController, userController, widget) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize
              .min, // Adjust the bottom sheet height based on content
          children: [
            Text(
              'create_group'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16, color: colorScheme(context).onSurface),
            ),
            const SizedBox(height: 16), // Space between title and input field
            CustomTextFormField(
              hint: 'search_hint'.tr(),
              borderColor: colorScheme(context).outline.withOpacity(0.4),
              fillColor: colorScheme(context).surface,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SvgPicture.asset(AppIcons.filter),
              ),
              suffixConstraints: const BoxConstraints(minHeight: 20),
              onChanged: groupChatController.filterList,
            ),
            const SizedBox(height: 16), // Space between input fields
            Text(
              'select_members'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16, color: colorScheme(context).onSurface),
            ),
            const SizedBox(height: 16), // Space before the member list

            // Members List with Cached Network Image and Checkbox
            SizedBox(
              height:
                  200, // Set fixed height for member list in the bottom sheet
              child: ListView.builder(
                itemCount: groupChatController.isLoadingFollwers
                    ? 4
                    : groupChatController.filteredFollowerList.length,
                itemBuilder: (context, index) {
                  if (groupChatController.isLoadingFollwers) {
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
                      groupChatController.filteredFollowerList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Add space between items
                    child: ListTile(
                      contentPadding: EdgeInsets.zero, // Remove default padding
                      leading: CachedNetworkImage(
                        imageUrl: follower.profileImage,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 25,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(
                        follower.username.initCapitalized,
                        style: textTheme(context).titleSmall,
                      ),
                      trailing: Checkbox(
                        value: groupChatController.memberList
                            .contains(follower.userId),
                        onChanged: (bool? value) {
                          groupChatController.addMember(follower.userId);
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
            // Create Button
            CustomButton(
              height: 45,
              onTap: () {
                Navigator.pop(context);
              },
              text: 'confirm'.tr(),
            ),
          ],
        );
      }),
    );
  }
}

class Member {
  String name;
  String avatarUrl;
  bool isSelected;

  Member({
    required this.name,
    required this.avatarUrl,
    required this.isSelected,
  });
}
