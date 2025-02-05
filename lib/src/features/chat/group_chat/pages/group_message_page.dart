import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/extensions.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/chat/group_chat/model/message_model.dart';
import '../../../_user_data/models/user_profile_model.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_shimmer.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../home/widget/show_full_screen_image.dart';
import '../controller/group_messages_controller.dart';
import '../model/joined_chat_group_model.dart';
import 'group_detail_page.dart';

class GroupMessagePage extends StatefulWidget {
  final JoinedChatGroupModel group;

  const GroupMessagePage({super.key, required this.group});

  @override
  State<GroupMessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<GroupMessagePage> {
  late GroupMessagesController _groupMessagesController;

  @override
  void initState() {
    _groupMessagesController =
        Provider.of<GroupMessagesController>(context, listen: false);
    _groupMessagesController.scrollController = ScrollController();
    _groupMessagesController.scrollController
        .addListener(_groupMessagesController.scrollListener);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _groupMessagesController.setGroup(widget.group);
      _groupMessagesController.markAsRead();
      _groupMessagesController.clearMessages();
      _groupMessagesController.toggleLoading();
      await _groupMessagesController.fetchMessages(groupId: widget.group.id);
      _groupMessagesController.toggleLoading();
    });
  }

  Future<void> onRefresh() async {
    _groupMessagesController.toggleLoading();
    await _groupMessagesController.fetchMessages(groupId: widget.group.id);
    _groupMessagesController.toggleLoading();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groupMessagesController.clearAll();
    });
    super.dispose();
  }

  void showEmojiBottomSheet({
    required GroupChatMessageModel message,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              Navigator.pop(context);

              // Provider.of<MessageProvider>(context, listen: false)
              //     .addReactionToMessage(
              //         message: message, reaction: emoji.emoji);
            },
          ),
        );
      },
    );
  }

  // Show full-screen image with animation and close button
  void _showFullScreenImage(String imageUrl) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: FullScreenImageViewer(imageUrl: imageUrl),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: AppColor.hintText,
        title: Consumer<GroupMessagesController>(
            builder: (context, messageController, widget) {
          return GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: WhatsAppGroupDetails(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back)),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CachedNetworkImage(
                    imageUrl: messageController.currentGroup?.iconUrl ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CustomShimmer(
                        height: 40,
                        width: 40,
                        radius: 20,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageController.currentGroup?.name.initCapitalized ??
                          '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: colorScheme(context).onSurface),
                    ),
                    Text(
                      'Group Chat',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColor.hintText),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        actions: [
          SvgPicture.asset(AppIcons.callIcon),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(AppIcons.videoIcon),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer2<GroupMessagesController, UserController>(
          builder: (context, messageController, userController, child) {
            log(messageController.messages.length.toString());
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: AppColor.lightBlack.withOpacity(0.3)),
                      bottom: BorderSide(
                          color: AppColor.lightBlack.withOpacity(0.3)),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.group.description.initCapitalized,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context).titleMedium!.copyWith(
                          letterSpacing: 0,
                          color: colorScheme(context).primary),
                    ),
                  ),
                ),
                Expanded(
                  child: (messageController.messages.isEmpty &&
                          !messageController.isLoading)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('No Message found!'),
                              TextButton(
                                  onPressed: onRefresh,
                                  child: const Text('Refresh!')),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          // controller: messageController.scrollController,
                          controller: messageController.scrollController,
                          reverse: true,
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: messageController.isLoading
                                    ? 15
                                    : messageController.messages.length,
                                itemBuilder: (context, index) {
                                  if (messageController.isLoading) {
                                    return index % 2 == 0
                                        ? const Row(
                                            children: [
                                              CustomShimmer(
                                                  height: 40,
                                                  width: 40,
                                                  radius: 20),
                                              SizedBox(width: 8),
                                              CustomShimmer(
                                                  height: 15, width: 180),
                                            ],
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              CustomShimmer(
                                                  height: 15, width: 180),
                                              SizedBox(width: 8),
                                              CustomShimmer(
                                                  height: 40,
                                                  width: 40,
                                                  radius: 20),
                                            ],
                                          );
                                  }
                                  final message =
                                      messageController.messages[index];

                                  final heroTag = message.message ??
                                      message.imageUrl ??
                                      'default-hero-tag-$index';

                                  return GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ReactionsDialogWidget(
                                          id: heroTag,
                                          messageWidget: buildMessageWidget(
                                              message, userController.user!),
                                          onReactionTap: (reaction) {
                                            if (reaction == '➕') {
                                              showEmojiBottomSheet(
                                                  message: message);
                                            } else {
                                              // messageController.addReactionToMessage(
                                              //   message: message,
                                              //   reaction: reaction,
                                              // );
                                            }
                                          },
                                          widgetAlignment: message.userId ==
                                                  userController.user!.id
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          // ignore: non_constant_identifier_names
                                          onContextMenuTap: (MenuItem) {},
                                        ),
                                      );
                                    },
                                    child: buildMessageWidget(
                                        message, userController.user!),
                                  );
                                },
                              ),
                              if (messageController.loadingNewItems)
                                SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
                buildChatInputField(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMessageWidget(GroupChatMessageModel message, UserProfile user) {
    bool isSender = user.id == message.user.id;
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender)
          ClipOval(
            child: Image.network(
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              message.user.profileImage,
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
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 8 : 0),
            topRight: Radius.circular(isSender ? 0 : 8),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                alignment:
                    isSender ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: isSender
                      ? colorScheme(context).primary.withOpacity(0.3)
                      : colorScheme(context).onPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSender ? 8 : 0),
                    topRight: Radius.circular(isSender ? 0 : 8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  border: Border.all(
                    color: colorScheme(context).outline.withOpacity(0.2),
                  ),
                ),
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSender ? 8 : 0),
                          topRight: Radius.circular(isSender ? 0 : 8),
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showFullScreenImage(message.imageUrl!);
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: height * 0.2,
                              maxWidth: width * 0.6,
                            ),
                            child: Image.network(
                              message.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return CustomShimmer(
                                  width: width * 0.6,
                                  height: height * 0.2,
                                  radius: 8,
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
                            ),
                          ),
                        ),
                      ),
                    if (message.message != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * 0.6),
                            child: Text(message.message!)),
                      ),
                  ],
                ),
              ),
              // if (message.reactions.isNotEmpty)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 12, right: 12),
              //     child: Container(
              //       constraints: const BoxConstraints(maxHeight: 100),
              //       child: Wrap(
              //         children: message.reactions
              //             .map((reaction) => Padding(
              //                   padding: const EdgeInsets.only(right: 4),
              //                   child: Text(
              //                     reaction,
              //                     style: const TextStyle(fontSize: 18),
              //                   ),
              //                 ))
              //             .toList(),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
        if (isSender)
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: CachedNetworkImage(
              imageUrl: message.user.profileImage,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CustomShimmer(
                  height: 40,
                  width: 40,
                  radius: 25,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
      ],
    );
  }

  Widget buildChatInputField(BuildContext context) {
    final messageController =
        Provider.of<GroupMessagesController>(context, listen: false);
    final userController = Provider.of<UserController>(context, listen: false);

    return SizedBox(
      height: 50,
      child: CustomTextFormField(
        hint: 'Type..',
        focusNode: messageController.focusNode,
        controller: messageController.messageController,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => messageController.pickImageFromCamera(
              () => context.pushNamed(AppRoute.sendSelectedImage, extra: {
                'image': messageController.image!,
                'isIndividual': false
              }),
            ),
            child: SvgPicture.asset(
              AppIcons.chatCamera,
              height: 24,
            ),
          ),
        ),
        borderColor: AppColor.hintText,
        prefixConstraints: const BoxConstraints(minHeight: 24),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.mikeIcon),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => messageController.pickImageFromGallery(
                () => context.pushNamed(AppRoute.sendSelectedImage, extra: {
                  'image': messageController.image!,
                  'isIndividual': false
                }),
              ),
              child: SvgPicture.asset(AppIcons.chatGalleryIcon),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (messageController.messageController.text.isNotEmpty) {
                  messageController.sendMessage(
                    message: messageController.messageController.text.trim(),
                    user: userController.user!,
                  );
                }
              },
              child: SvgPicture.asset(AppIcons.outlineSendIcon),
            ),
            const SizedBox(width: 10),
          ],
        ),
        hintColor: colorScheme(context).onSurface,
      ),
    );
  }
}
