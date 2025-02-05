import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/features/chat/group_chat/controller/group_messages_controller.dart';

import '../../../../common/constants/global_variables.dart';

class GroupChatDialogs {
  // Delete account dialog
  static Future<bool> showDeleteAccountDialog(BuildContext context,
      GroupMessagesController groupMessagesController) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).outline)),
            ),
            TextButton(
              onPressed: () async {
                var overlay = context.loaderOverlay;
                overlay.show();
                bool done = await groupMessagesController.deleteGroup();
                if (context.mounted) {
                  overlay.hide();
                  Navigator.of(context).pop(done);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorScheme(context)
                    .error, // Red color for the Delete Account button
              ),
              child: Text('Delete Group',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).onError)),
            ),
          ],
        );
      },
    );
  }

  // Remove User Dialog
  static Future<bool> showRemoveUserDialog(BuildContext context,
      {required int memberId,
      required GroupMessagesController groupMessagesController}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove User from Group'),
          content: Text(
              'Are you sure you want to remove this user from the group? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).outline)),
            ),
            TextButton(
              onPressed: () async {
                var overlay = context.loaderOverlay;
                overlay.show();
                bool done = await groupMessagesController.removeMemberFromGroup(
                    memberId: memberId);
                if (context.mounted) {
                  overlay.hide();
                  Navigator.of(context).pop(done);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorScheme(context)
                    .error, // Red color for the Remove User button
              ),
              child: Text('Remove User',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).onError)),
            ),
          ],
        );
      },
    );
  }

  // Leave Group Dialog
  static Future<bool> showLeaveGroupDialog(BuildContext context,
      GroupMessagesController groupMessagesController) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Leave Group'),
          content: Text(
              'Are you sure you want to leave this group? You will no longer be able to send messages or receive notifications from this group.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).outline)),
            ),
            TextButton(
              onPressed: () async {
                var overlay = context.loaderOverlay;
                overlay.show();
                bool done = await groupMessagesController.leaveGroup();
                if (context.mounted) {
                  overlay.hide();
                  Navigator.of(context).pop(done);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorScheme(context)
                    .error, // Red color for the Leave Group button
              ),
              child: Text('Leave Group',
                  style: textTheme(context)
                      .bodyLarge
                      ?.copyWith(color: colorScheme(context).onError)),
            ),
          ],
        );
      },
    );
  }
}
