import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pet_project/src/features/chat/individual_chat/controller/chat_room_controller.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/chat/group_chat/controller/group_messages_controller.dart';
import 'package:provider/provider.dart';
import '../../common/constants/app_colors.dart';
import '../../common/constants/app_images.dart';
import '../../common/constants/global_variables.dart';
import 'individual_chat/controller/chat_message_controller.dart';

class SendSelectedImagePage extends StatefulWidget {
  final File image;
  final bool isIndividual;
  final int? individualChatUserID;
  const SendSelectedImagePage(
      {super.key,
      required this.image,
      required this.isIndividual,
      this.individualChatUserID});

  @override
  State<SendSelectedImagePage> createState() => _SendSelectedImagePageState();
}

class _SendSelectedImagePageState extends State<SendSelectedImagePage> {
  TextEditingController messageTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer4<GroupMessagesController, ChatMessagesController,
                ChatRoomController, UserController>(
            builder: (context, groupMessageController, chatMessageController,
                chatRoomController, userController, _) {
          return Stack(
            children: [
              Image.file(
                widget.image,
                height: height,
                width: width,
                fit: BoxFit.contain,
              ),
              Positioned(
                bottom: 10,
                right: 16,
                left: 16,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: CustomTextFormField(
                    hint: 'Type..',
                    controller: messageTEC,
                    borderColor: AppColor.hintText,
                    suffixConstraints: const BoxConstraints(minHeight: 30),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () async {
                          var overlay = context.loaderOverlay;
                          overlay.show();

                          if (widget.isIndividual) {
                            await chatMessageController.sendMessage(
                                otherId: widget.individualChatUserID!,
                                image: widget.image,
                                message: messageTEC.text.isNotEmpty
                                    ? messageTEC.text.trim()
                                    : null,
                                user: userController.user!);
                            chatRoomController.fetchChats();
                          } else {
                            await groupMessageController.sendMessage(
                                image: widget.image,
                                message: messageTEC.text.isNotEmpty
                                    ? messageTEC.text.trim()
                                    : null,
                                user: userController.user!);
                          }

                          overlay.hide();
                          if (context.mounted) {
                            context.pop();
                          }
                        },
                        child: SvgPicture.asset(
                          AppIcons.outlineSendIcon,
                        ),
                      ),
                    ),
                    hintColor: colorScheme(context).onSurface,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 12,
                child: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme(context).onSurface,
                    ),
                    child: Icon(
                      Icons.close,
                      color: colorScheme(context).onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
