import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_project/src/features/chat/individual_chat/controller/chat_message_controller.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/chat/individual_chat/controller/chat_room_controller.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../../router/routes.dart';

class IndividualChatPage extends StatefulWidget {
  const IndividualChatPage({super.key});

  @override
  PetFollowerScreenState createState() => PetFollowerScreenState();
}

class PetFollowerScreenState extends State<IndividualChatPage> {
  TextEditingController searchController = TextEditingController();
  bool isChatSelected = true; // Default selection is "Chat"

  late ChatRoomController _chatRoomController;
  @override
  void initState() {
    _chatRoomController =
        Provider.of<ChatRoomController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatRoomController.firstTimeLoading) {
        _chatRoomController.fetchChats();
      }
    });
  }

  Future<void> refreshPage() async {
    await _chatRoomController.fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      child: Scaffold(
        body: Consumer<ChatRoomController>(
            builder: (context, chatRoomController, widget) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "chat".tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 20, color: colorScheme(context).onSurface),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoute.chatRequest);
                      },
                      child: Text(
                        "chat_request".tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 20,
                            color: colorScheme(context).onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     showSearch(
              //       context: context,
              //       delegate: CustomSearchDelegate(
              //         searchTerms: [
              //           'Jerome Bell'.tr(),
              //           'Eleanor Pena'.tr(),
              //           'Kathryn Murphy'.tr(),
              //           'fish'.tr()
              //         ],
              //       ),
              //     );
              //   },
              //   child:
              Padding(
                padding: const EdgeInsets.all(16.0),
                // child: AbsorbPointer(
                child: CustomTextFormField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(AppIcons.outlineSearch),
                  ),
                  readOnly: true,
                  hint: 'search_hint'.tr(),
                  borderColor: colorScheme(context).outline.withOpacity(0.4),
                  fillColor: colorScheme(context).surface,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: SvgPicture.asset(AppIcons.filter),
                  ),
                  suffixConstraints: const BoxConstraints(minHeight: 20),
                  onChanged: chatRoomController.filterList,
                ),
                // ),
              ),
              // ),
              Expanded(
                child: ListView.separated(
                    itemCount: chatRoomController.isLoading
                        ? 10
                        : chatRoomController.filteredChatList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (chatRoomController.isLoading) {
                        return Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: CustomShimmer(
                                height: 45,
                                width: 45,
                                radius: 25,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomShimmer(
                                  height: 15,
                                  width: 120,
                                ),
                                SizedBox(height: 6),
                                CustomShimmer(
                                  height: 15,
                                  width: 250,
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      final chat = chatRoomController.filteredChatList[index];
                      return ListTile(
                        onTap: () {
                          context.pushNamed(AppRoute.messagePage,
                              extra: chat.otherUser);
                        },
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(
                                chat.otherUser.profileImage)),
                        title: Text(
                          chat.otherUser.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: colorScheme(context).onSurface),
                        ),
                        subtitle: Text(
                          chat.latestMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: colorScheme(context)
                                        .onSurface
                                        .withOpacity(0.4),
                                  ),
                        ),
                        trailing: Consumer<ChatMessagesController>(
                            builder: (context, messageController, widget) {
                          return IconButton(
                            onPressed: () =>
                                messageController.pickImageFromCamera(
                              () => context.pushNamed(
                                  AppRoute.sendSelectedImage,
                                  extra: {
                                    'image': messageController.image!,
                                    'isIndividual': true,
                                    'individualChatUserID': chat.otherUser.id,
                                  }),
                            ),
                            icon: SvgPicture.asset(
                              AppIcons.chatCamera,
                              width: 24,
                              height: 24,
                            ),
                          );
                        }),
                      );
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
