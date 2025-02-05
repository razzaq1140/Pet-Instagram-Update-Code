import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/common/constants/extensions.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/features/chat/group_chat/controller/group_chat_controller.dart';
import '/src/features/chat/group_chat/widget/group_chat_button.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../model/joined_chat_group_model.dart';

class GroupChatWidget extends StatefulWidget {
  final JoinedChatGroupModel group;

  const GroupChatWidget({
    super.key,
    required this.group,
  });

  @override
  State<GroupChatWidget> createState() => _GroupChatWidgetState();
}

class _GroupChatWidgetState extends State<GroupChatWidget> {
  String convertCountToReadable(int count) {
    if (count >= 1e9) {
      return '${(count / 1e9).toStringAsFixed(1)}B'; // Billion
    } else if (count >= 1e6) {
      return '${(count / 1e6).toStringAsFixed(1)}M'; // Million
    } else if (count >= 1e3) {
      return '${(count / 1e3).toStringAsFixed(1)}K'; // Thousand
    } else {
      return count.toString(); // Return count as is for numbers less than 1000
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupChatController>(
      builder: (context, groupChatController, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GestureDetector(
            // onTap: () {

            // PersistentNavBarNavigator.pushNewScreen(
            //   context,
            //   screen: GroupMessagePage(
            //     group: widget.group,
            //   ),
            //   withNavBar: true,
            //   pageTransitionAnimation: PageTransitionAnimation.fade,
            // );
            // },
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0.01,
                    blurRadius: 3,
                    offset: const Offset(-4, 7),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Group Image
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.group.iconUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CustomShimmer(
                              height: 120,
                              width: 120,
                              radius: 8,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  // Group Details
                  Positioned(
                    left: 110,
                    top: 10,
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width - 130,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.group.isPrivate
                            ? const Color.fromARGB(255, 255, 220, 232)
                            : colorScheme(context).surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Group name and members count
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.group.name.initCapitalized} ${widget.group.isPrivate ? '(Private)' : ''}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme(context)
                                                  .onSurface),
                                    ),
                                    Text(
                                      '${convertCountToReadable(widget.group.memberCount)} Members',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              fontSize: 10,
                                              color: colorScheme(context)
                                                  .onSurface),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Favourite Icon
                                GestureDetector(
                                  onTap: () async {
                                    if (!groupChatController.isBusy) {
                                      await groupChatController
                                          .toggleFavorite(
                                              groupId: widget.group.id)
                                          .then((_) {
                                        widget.group.isFavorite =
                                            !widget.group.isFavorite;
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorScheme(context)
                                              .primary
                                              .withOpacity(0.4)),
                                      child: Icon(
                                        widget.group.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite,
                                        color: widget.group.isFavorite
                                            ? Theme.of(context)
                                                .colorScheme
                                                .error
                                            : colorScheme(context).onPrimary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (!groupChatController.isBusy) {
                                      await groupChatController
                                          .togglePin(groupId: widget.group.id)
                                          .then((_) {
                                        widget.group.isPinned =
                                            !widget.group.isPinned;
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorScheme(context)
                                              .primary
                                              .withOpacity(0.4)),
                                      child: Transform.rotate(
                                        angle: 26,
                                        child: Icon(
                                          widget.group.isPinned
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Unread: ${widget.group.unreadCount} messages',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontSize: 12,
                                          color:
                                              colorScheme(context).onSurface),
                                ),
                              ),
                              const SizedBox(height: 25)
                            ],
                          ),
                          // AvatarStack(
                          //   height: 25,
                          //   width: 70,
                          //   avatars: [
                          //     for (var n = 0; n < 4; n++)
                          //       const CachedNetworkImageProvider(
                          //         'https://images.unsplash.com/photo-1518378188025-22bd89516ee2?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          //       ),
                          //   ],
                          // ),

                          GroupChatButton(
                            onTap: () {
                              context.pushNamed(AppRoute.groupChat,
                                  extra: widget.group);
                              // PersistentNavBarNavigator.pushNewScreen(
                              //   context,
                              //   screen: GroupMessagePage(
                              //     group: widget.group,
                              //   ),
                              //   withNavBar: true,
                              //   pageTransitionAnimation:
                              //       PageTransitionAnimation.fade,
                              // );
                            },
                            btText: 'Chat',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
