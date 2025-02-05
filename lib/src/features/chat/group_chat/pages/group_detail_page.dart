import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/extensions.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/chat/group_chat/controller/group_chat_controller.dart';
import '/src/features/chat/group_chat/controller/group_messages_controller.dart';
import '/src/features/chat/group_chat/helper/group_chat_dialogs.dart';
import '/src/features/chat/group_chat/pages/add_member_page.dart';
import 'package:provider/provider.dart';
import '../../../../common/widget/custom_shimmer.dart';
import '../../../_user_data/controllers/user_controller.dart';
import 'change_group_details.dart';

class WhatsAppGroupDetails extends StatefulWidget {
  const WhatsAppGroupDetails({super.key});

  @override
  State<WhatsAppGroupDetails> createState() => _WhatsAppGroupDetailsState();
}

class _WhatsAppGroupDetailsState extends State<WhatsAppGroupDetails> {
  late GroupMessagesController groupMessagesController;
  @override
  void initState() {
    groupMessagesController =
        Provider.of<GroupMessagesController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupMessagesController.fetchMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer3<GroupMessagesController, UserController,
                GroupChatController>(
            builder: (context, messageController, userController,
                groupChatController, widget) {
          return Column(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    messageController.currentGroup!.iconUrl),
                radius: 60,
              ),
              SizedBox(height: 20),
              Text(
                messageController.currentGroup!.name.initCapitalized,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(messageController.currentGroup!.description.initCapitalized,
                  style: TextStyle(fontSize: 16)),
              if (userController.user!.id ==
                  messageController.currentGroup!.creator.id) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ChangeGroupDetailsScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      child: Text('Edit Details')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Private'),
                    Switch(
                      value: messageController.currentGroup!.isPrivate,
                      onChanged: (bool value) async {
                        await messageController.updateGroupInfo(
                          groupId: messageController.currentGroup!.id,
                          isPrivate: value ? 1 : 0,
                        );
                      },
                    ),
                  ],
                )
              ],
              Divider(color: colorScheme(context).outline.withOpacity(0.2)),
              Row(
                children: [
                  Text(
                    'Group Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  if (userController.user!.id ==
                      messageController.currentGroup!.creator.id) ...[
                    IconButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: AddRemoveMemberPage(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        icon: Icon(Icons.add))
                  ]
                ],
              ),

              // List of Participants
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 450),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: messageController.loadingMembers
                      ? 7
                      : messageController.memberList.length,
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    if (messageController.loadingMembers) {
                      return Row(
                        children: [
                          CustomShimmer(height: 40, width: 40, radius: 20),
                          SizedBox(width: 8),
                          Expanded(child: CustomShimmer(height: 15)),
                        ],
                      );
                    }

                    return ListTile(
                      onTap: () async {
                        log(messageController.memberList[index].toString());
                        if (!messageController
                            .memberList[index].pivot.isAdmin) {
                          await GroupChatDialogs.showRemoveUserDialog(
                            context,
                            memberId:
                                messageController.memberList[index].userId,
                            groupMessagesController: messageController,
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            messageController.memberList[index].profileImage),
                      ),
                      title: Text(messageController.memberList[index].name),
                      trailing: Text(
                          '${messageController.memberList[index].pivot.isAdmin ? '(Admin)' : ''} ${(userController.user!.id == messageController.memberList[index].userId) ? '(You)' : ''}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),

              ListTile(
                onTap: () async {
                  bool deleted = await GroupChatDialogs.showLeaveGroupDialog(
                      context, messageController);
                  groupChatController
                      .deleteGroup(messageController.currentGroup!.id);
                  if (context.mounted) {
                    if (deleted) {
                      PersistentNavBarNavigator
                          .popUntilFirstScreenOnSelectedTabScreen(context);
                    }
                  }
                },
                leading: Icon(Icons.logout),
                title: Text('Leave Group'),
              ),
              if (userController.user!.id ==
                  messageController.currentGroup!.creator.id)
                ElevatedButton(
                  onPressed: () async {
                    bool deleted =
                        await GroupChatDialogs.showDeleteAccountDialog(
                            context, messageController);
                    groupChatController
                        .deleteGroup(messageController.currentGroup!.id);
                    if (context.mounted) {
                      if (deleted) {
                        PersistentNavBarNavigator
                            .popUntilFirstScreenOnSelectedTabScreen(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme(context).error,
                  ),
                  child: Text('Delete Group',
                      style: textTheme(context)
                          .bodyLarge
                          ?.copyWith(color: colorScheme(context).onError)),
                ),
            ],
          );
        }),
      ),
    );
  }
}
