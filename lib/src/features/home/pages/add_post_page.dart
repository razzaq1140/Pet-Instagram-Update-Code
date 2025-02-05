import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/widget/custom_button.dart';
import '/src/features/home/controller/home_controller.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/utils/validation.dart';
import '../../../common/widget/custom_text_field.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController postDesc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Consumer<HomeController>(
              builder: (context, homeController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(
                        color: colorScheme(context).outlineVariant, width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "upload_picture".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeController.pickedImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () => homeController.pickImage(context),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    color: colorScheme(context).surface,
                                  ),
                                  child: Icon(
                                    Icons.add_box_outlined,
                                    color: colorScheme(context).outline,
                                    size: 18,
                                  ),
                                ),
                              );
                            } else {
                              final pickedImage =
                                  homeController.pickedImages[index - 1];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: colorScheme(context).surface,
                                        image: DecorationImage(
                                          image: FileImage(pickedImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => homeController
                                            .removeImage(index - 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red.withOpacity(0.7),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: postDesc,
                        hint: 'Lorem ipsum dolor sit amet',
                        inputAction: TextInputAction.next,
                        fillColor: colorScheme(context).surface,
                        maxline: 7,
                        validator: (value) => Validation.fieldValidation(
                            value, "Post Description"),
                      ),
                      const SizedBox(height: 50),
                      CustomButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              if (homeController.pickedImages.isNotEmpty) {
                                var overlay = context.loaderOverlay;
                                overlay.show();
                                homeController.submitAPost(
                                  description: postDesc.text,
                                  files: homeController.pickedImages,
                                  onSuccess: (success) {
                                    showSnackbar(message: 'Post Submitted');
                                    overlay.hide();
                                    homeController.pickedImages.clear();
                                    postDesc.clear();
                                    PersistentNavBarNavigator.pop(context);
                                  },
                                  onError: (error) {
                                    overlay.hide();
                                    showSnackbar(message: error, isError: true);
                                  },
                                  context: context,
                                );
                              } else {
                                showSnackbar(
                                    message: 'Please add an Image.',
                                    isError: true);
                              }
                            }
                          },
                          text: 'Post'),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
