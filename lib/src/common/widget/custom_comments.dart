import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/profile/pages/friend_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../features/_user_data/controllers/user_controller.dart';
import '../../features/profile/pages/my_profile_page.dart';
import '../../models/comment_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';

class CustomComment extends StatefulWidget {
  final int postUserId;
  final String profileImage;

  final List<CommentModel> comments;
  final Function(int id) onLikeTapped;
  final Future<CommentModel?> Function(String comment) onSendComment;

  const CustomComment({
    super.key,
    required this.postUserId,
    required this.profileImage,
    required this.comments,
    required this.onLikeTapped,
    required this.onSendComment,
  });

  @override
  CustomCommentState createState() => CustomCommentState();
}

class CustomCommentState extends State<CustomComment> {
  final TextEditingController _commentController = TextEditingController();
  late UserController _userController;

  String changeToTimeAgo(DateTime date) {
    String timeAgo = timeago.format(date);
    return timeAgo;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userController = Provider.of<UserController>(context, listen: false);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColor.hintText,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.comments.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = widget.comments[index];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          if (_userController.user!.id == comment.user.id) {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const MyProfilePage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          } else {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: FriendProfilePage(
                                userId: comment.user.id,
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          }
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                              child: Image.network(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            comment.user.profileImage,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              log('${comment.user.profileImage} error: $error ');

                              return Image.asset(
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                AppImages.pinkDog,
                              );
                            },
                          )),
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          if (_userController.user!.id == comment.user.id) {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const MyProfilePage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          } else {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: FriendProfilePage(
                                userId: comment.user.id,
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(comment.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            if (comment.user.id == widget.postUserId)
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  'Author',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.hintText,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.content),
                          Row(
                            children: [
                              Text(
                                  changeToTimeAgo(DateTime.parse(
                                      comment.createdAt.toString())),
                                  style: const TextStyle(
                                      color: AppColor.hintText, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          await widget.onLikeTapped(comment.id);
                          comment.likedByUser = !comment.likedByUser;
                          setState(() {});
                        },
                        child: Icon(
                          comment.likedByUser
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: comment.likedByUser
                              ? AppColor.appRed
                              : AppColor.hintText,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        widget.profileImage,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _commentController,
                        hint: 'Add a comment...',
                        borderColor:
                            colorScheme(context).outline.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        if (_commentController.text.isNotEmpty) {
                          var newComment = await widget
                              .onSendComment(_commentController.text);
                          if (newComment != null) {
                            widget.comments.add(newComment);
                            _commentController.clear();
                            setState(() {});
                          }
                        }
                      },
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
