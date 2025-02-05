import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_shimmer.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/chat/group_chat/controller/group_chat_controller.dart';
import '/src/features/chat/group_chat/widget/group_chat_search_delegate.dart';
import '/src/features/chat/group_chat/widget/group_bottom_sheet.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants/global_variables.dart';
import '../widget/group_chat_widget.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late GroupChatController _groupChatController;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    _groupChatController =
        Provider.of<GroupChatController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_groupChatController.firstTimeLoading) {
        _groupChatController.fetchGroups();
      }
    });
  }

  Future<void> refreshPage() async {
    await _groupChatController.fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: refreshPage,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Consumer<GroupChatController>(
            builder: (context, groupChatController, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "group_chat".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 20,
                                  color: colorScheme(context).onSurface),
                        ),
                        TextButton(
                          child: Text("create_group".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      color: colorScheme(context).primary)),
                          onPressed: () {
                            showMyDialog(context);
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Consumer<GroupChatController>(
                      builder: (context, controller, child) {
                        return GestureDetector(
                          onTap: () {
                            showSearch(
                              context: context,
                              delegate: GroupChatSearchDelegate(
                                  groupList: controller.groupList),
                            );
                          },
                          child: AbsorbPointer(
                            // AbsorbPointer will ensure the text field doesn't take direct input
                            child: CustomTextFormField(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(AppIcons.outlineSearch),
                              ),

                              readOnly:
                                  true, // Make sure the field is read-only
                              hint: 'search_hint'.tr(),
                              borderColor:
                                  colorScheme(context).outline.withOpacity(0.4),
                              fillColor: colorScheme(context).surface,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: SvgPicture.asset(AppIcons.filter),
                              ),
                              suffixConstraints:
                                  const BoxConstraints(minHeight: 20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: (groupChatController.groupList.isEmpty &&
                            !groupChatController.isLoading)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('No Groups Joined'),
                              TextButton(
                                  onPressed: refreshPage,
                                  child: const Text('Refresh')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: groupChatController.isLoading
                                ? 6
                                : groupChatController.groupList.length,
                            itemBuilder: (context, index) {
                              if (groupChatController.isLoading) {
                                return const SizedBox(
                                  height: 80,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      CustomShimmer(
                                        height: 75,
                                        width: 75,
                                        radius: 12,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomShimmer(height: 15),
                                            CustomShimmer(height: 30),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return GestureDetector(
                                onTap: () => context.pushNamed(
                                    AppRoute.groupChat,
                                    extra:
                                        groupChatController.groupList[index]),
                                child: GroupChatWidget(
                                  group: groupChatController.groupList[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  showMyDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController groupNameController = TextEditingController();
    TextEditingController groupDescriptionController = TextEditingController();
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dialog",
      pageBuilder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.1),
          body: Consumer<GroupChatController>(
              builder: (context, controller, widget) {
            return Form(
              key: formKey,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // 90% of the screen width
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('create_group_chat'.tr()),
                            const SizedBox(height: 8),
                            Text('upload_group_image'.tr()),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                InkWell(
                                  onTap: controller.pickImage,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        controller.groupImage != null
                                            ? FileImage(controller.groupImage!)
                                            : null,
                                    child: controller.groupImage == null
                                        ? const Icon(Icons.camera_alt)
                                        : null,
                                  ),
                                ),
                                const Spacer(),
                                if (controller.showImageWarning)
                                  Text(
                                    'Please Select a group image',
                                    style: textTheme(context)
                                        .bodyMedium
                                        ?.copyWith(
                                            color: colorScheme(context).error),
                                  ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('enter_group_name'.tr(),
                                style: textTheme(context).titleMedium!.copyWith(
                                      color: colorScheme(context).outline,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    )),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              controller: groupNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'name_cannot_be_empty'.tr();
                                }
                                return null;
                              },
                              contentPadding: const EdgeInsets.all(8),
                              textStyle: textTheme(context)
                                  .labelSmall!
                                  .copyWith(
                                      color: colorScheme(context).outline,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                              hint: 'enter_group_name'.tr(),
                              borderColor:
                                  colorScheme(context).outline.withOpacity(0.4),
                            ),
                            const SizedBox(height: 8),
                            Text('enter_group_description'.tr(),
                                style: textTheme(context).titleMedium!.copyWith(
                                      color: colorScheme(context).outline,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    )),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              controller: groupDescriptionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'description_cannot_be_empty'.tr();
                                }
                                return null;
                              },
                              contentPadding: const EdgeInsets.all(8),
                              maxline: 2,
                              textStyle: textTheme(context)
                                  .labelSmall!
                                  .copyWith(
                                      color: colorScheme(context).outline,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                              hint:
                                  '''Lorem Ipsum has been the industry's stand ard dummy text ever since Lorem Ipsum has been the industry's standard .''',
                              borderColor:
                                  colorScheme(context).outline.withOpacity(0.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'group_category'.tr(),
                              style: textTheme(context).titleMedium!.copyWith(
                                    color: colorScheme(context).outline,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            ),
                            Row(
                              children: [
                                Text('public'.tr(),
                                    style: textTheme(context)
                                        .labelLarge!
                                        .copyWith(
                                          color: colorScheme(context).outline,
                                        )),
                                Radio<String>(
                                  value: 'Public',
                                  groupValue: controller.selectedPrivacyValue,
                                  onChanged: controller.changeGroupPrivacy,
                                ),
                                Text('private'.tr(),
                                    style: textTheme(context)
                                        .labelLarge!
                                        .copyWith(
                                          color: colorScheme(context).outline,
                                        )),
                                Radio<String>(
                                  value: 'Private',
                                  groupValue: controller.selectedPrivacyValue,
                                  onChanged: controller.changeGroupPrivacy,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showCreateGroupBottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme(context).primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'select_group_members'.tr(),
                                  style: textTheme(context)
                                      .labelMedium!
                                      .copyWith(
                                        color: colorScheme(context).onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                                height: 45,
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (controller.groupImage == null) {
                                      controller.toggleWarning(true);
                                      return;
                                    }
                                    var overlay = context.loaderOverlay;
                                    overlay.show();
                                    await controller.createGroup(
                                      context,
                                      name: groupNameController.text.trim(),
                                      description: groupDescriptionController
                                          .text
                                          .trim(),
                                    );
                                    await controller.fetchGroups();

                                    controller.clearMembers();
                                    if (context.mounted) {
                                      overlay.hide();
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                text: 'create_group'.tr(),
                                textSize: 16),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                controller.clearMembers();
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: colorScheme(context)
                                          .outline
                                          .withOpacity(0.4)),
                                ),
                                child: Center(
                                  child: Text('back'.tr(),
                                      style: textTheme(context)
                                          .titleSmall!
                                          .copyWith(
                                            color: colorScheme(context)
                                                .outline
                                                .withOpacity(0.4),
                                          )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void showCreateGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the bottom sheet to be scrollable if content exceeds screen size
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => const CreateGroupBottomSheet(),
    );
  }
}
