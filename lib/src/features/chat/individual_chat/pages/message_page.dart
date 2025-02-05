import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_shimmer.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../../router/routes.dart';
import '../../../_user_data/controllers/user_controller.dart';
import '../../../_user_data/models/user_profile_model.dart';
import '../../../home/widget/show_full_screen_image.dart';
import '../controller/chat_room_controller.dart';
import '../controller/chat_message_controller.dart';
import '../models/chat_message_model.dart';
import '../models/chat_room_model.dart';

class MessagePage extends StatefulWidget {
  final ChatRoomOtherUserModel chatRoomOtherUserModel;

  const MessagePage({super.key, required this.chatRoomOtherUserModel});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late ChatRoomController _chatRoomController;
  late ChatMessagesController _chatMessagesController;

  @override
  void initState() {
    _chatRoomController =
        Provider.of<ChatRoomController>(context, listen: false);
    _chatMessagesController =
        Provider.of<ChatMessagesController>(context, listen: false);
    _chatMessagesController.scrollController = ScrollController();
    _chatMessagesController.scrollController
        .addListener(_chatMessagesController.scrollListener);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _chatMessagesController.clearAll();
      _chatMessagesController.toggleLoading();
      if (_chatRoomController.chatList.isEmpty) {
        await _chatRoomController.fetchChats();
      }
      int? chatId;
      _chatRoomController.chatList.map(
        (chatRoom) {
          if (chatRoom.otherUser.id == widget.chatRoomOtherUserModel.id) {
            chatId = chatRoom.chatRoomId;
          }
        },
      ).toList();

      await _chatMessagesController.setChatId(chatId);
      await _chatMessagesController.fetchMessages();
      _chatMessagesController.toggleLoading();
    });
  }

  void showEmojiBottomSheet({
    required ChatMessageModel message,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              Navigator.pop(context);

              _chatMessagesController.addReactionToMessage(
                  message: message, reaction: emoji.emoji);
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

  Future<void> onRefresh() async {
    _chatMessagesController.toggleLoading();
    await _chatMessagesController.fetchMessages();
    _chatMessagesController.toggleLoading();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatMessagesController.clearScrollController();
      _chatMessagesController.clearAll();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: AppColor.hintText,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: const Icon(Icons.arrow_back)),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CachedNetworkImage(
                imageUrl: widget.chatRoomOtherUserModel.profileImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => CustomShimmer(
                  height: 40,
                  width: 40,
                  radius: 35,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatRoomOtherUserModel.username,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: colorScheme(context).onSurface),
                ),
                Text(
                  widget.chatRoomOtherUserModel.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColor.hintText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: SvgPicture.asset(AppIcons.callIcon),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(AppIcons.videoIcon),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer2<ChatMessagesController, UserController>(
          // Wrap in Consumer to listen to changes
          builder: (context, messageController, userController, _) {
            return Column(
              children: [
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
                                      message.image ??
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
                                          widgetAlignment: message.senderId ==
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
                buildChatInputField(context, userController.user!),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMessageWidget(ChatMessageModel message, UserProfile user) {
    bool isSender = user.id == message.sender.id;
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
              message.sender.profileImage,
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
                    if (message.image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSender ? 8 : 0),
                          topRight: Radius.circular(isSender ? 0 : 8),
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showFullScreenImage(message.image!);
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: height * 0.2,
                              maxWidth: width * 0.6,
                            ),
                            child: Image.network(
                              message.image!,
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
              imageUrl: user.profileImage,
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

  Widget buildChatInputField(BuildContext context, UserProfile user) {
    return SizedBox(
      height: 50,
      child: CustomTextFormField(
        hint: 'Type..',
        focusNode: _chatMessagesController.focusNode,
        controller: _chatMessagesController.messageController,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => _chatMessagesController.pickImageFromCamera(
              () => context.pushNamed(AppRoute.sendSelectedImage, extra: {
                'image': _chatMessagesController.image!,
                'isIndividual': true,
                'individualChatUserID': widget.chatRoomOtherUserModel.id,
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
        hintColor: colorScheme(context).onSurface,
        keyboardType: TextInputType.multiline,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppIcons.mikeIcon),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => _chatMessagesController.pickImageFromGallery(
                () => context.pushNamed(AppRoute.sendSelectedImage, extra: {
                  'image': _chatMessagesController.image!,
                  'isIndividual': true,
                  'individualChatUserID': widget.chatRoomOtherUserModel.id,
                }),
              ),
              child: SvgPicture.asset(AppIcons.chatGalleryIcon),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (_chatMessagesController.messageController.text.isNotEmpty) {
                  _chatMessagesController.sendMessage(
                    otherId: widget.chatRoomOtherUserModel.id,
                    message:
                        _chatMessagesController.messageController.text.trim(),
                    user: user,
                  );
                }
              },
              child: SvgPicture.asset(AppIcons.outlineSendIcon),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
