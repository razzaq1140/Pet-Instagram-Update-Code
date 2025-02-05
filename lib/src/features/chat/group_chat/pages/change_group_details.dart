import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/chat/group_chat/controller/group_messages_controller.dart';
import 'package:provider/provider.dart';
import '../../../../common/utils/validation.dart';
import '../controller/group_chat_controller.dart';

class ChangeGroupDetailsScreen extends StatefulWidget {
  const ChangeGroupDetailsScreen({super.key});

  @override
  State<ChangeGroupDetailsScreen> createState() =>
      _ChangeGroupDetailsScreenState();
}

class _ChangeGroupDetailsScreenState extends State<ChangeGroupDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var controller =
        Provider.of<GroupMessagesController>(context, listen: false);
    _nameController.text = controller.currentGroup!.name;
    _descriptionController.text = controller.currentGroup!.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Change Group Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Navigate back
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<GroupMessagesController, GroupChatController>(
            builder: (context, messagecontroller, groupChatController, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Group icon picker
                Center(
                  child: GestureDetector(
                    onTap: () => messagecontroller.pickGroupImage(),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: messagecontroller.groupImage != null
                          ? FileImage(messagecontroller.groupImage!)
                          : CachedNetworkImageProvider(
                              messagecontroller.currentGroup!.iconUrl),
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                CustomTextFormField(
                  controller: _nameController,
                  inputAction: TextInputAction.next,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'Enter new grou name',
                  validator: (value) =>
                      Validation.fieldValidation(value, 'Group name'),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _descriptionController,
                  inputAction: TextInputAction.next,
                  fillColor: colorScheme(context).surface,
                  maxline: 3,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'Enter group description',
                  validator: (value) =>
                      Validation.fieldValidation(value, 'Group description'),
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 40),
                CustomButton(
                    onTap: () async {
                      var overlay = context.loaderOverlay;

                      if (_formKey.currentState!.validate()) {
                        overlay.show();
                        if (messagecontroller.groupImage != null) {
                          String icon = await groupChatController.addGroupIcon(
                              groupId: messagecontroller.currentGroup!.id,
                              icon: messagecontroller.groupImage!);
                          if (icon.isNotEmpty) {
                            messagecontroller.currentGroup!.iconUrl = icon;
                          }
                        }
                        if (messagecontroller.currentGroup!.name !=
                                _nameController.text ||
                            messagecontroller.currentGroup!.description !=
                                _descriptionController.text) {
                          await messagecontroller.updateGroupInfo(
                            groupId: messagecontroller.currentGroup!.id,
                            name: _nameController.text,
                            description: _descriptionController.text,
                          );

                          messagecontroller.currentGroup!.name =
                              _nameController.text;
                          messagecontroller.currentGroup!.description =
                              _descriptionController.text;
                          messagecontroller
                              .setGroup(messagecontroller.currentGroup!);
                        }

                        messagecontroller.groupImage = null;
                        overlay.hide();
                      }
                    },
                    text: 'Save'),
              ],
            ),
          );
        }),
      ),
    );
  }
}
