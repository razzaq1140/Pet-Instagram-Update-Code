import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/feed_and_recipe/controller/recipe_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';

class UploadRecipePage extends StatefulWidget {
  const UploadRecipePage({super.key});

  @override
  State<UploadRecipePage> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<UploadRecipePage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController recipeName = TextEditingController();
  TextEditingController recipeCategory = TextEditingController();

  Future<void> _editDescription(BuildContext context) async {
    final controller = context.read<RecipeController>();
    final Object? editedData = await context.pushNamed(AppRoute.quillEditor);
    if (editedData != null && editedData is String) {
      controller.updateDescription(editedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Consumer<RecipeController>(
                builder: (context, recipeController, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'upload_recipe'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 20,
                            color: colorScheme(context).onSurface),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                            "add_recipe".tr(),
                            style: textTheme(context)
                                .headlineMedium
                                ?.copyWith(fontSize: 24),
                          ),
                        ),
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
                            itemCount: recipeController.pickedImages.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () =>
                                      recipeController.pickImage(context),
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
                                    recipeController.pickedImages[index - 1];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          onTap: () => recipeController
                                              .removeImage(index - 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.red.withOpacity(0.7),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "recipe_name".tr(),
                            style: textTheme(context).titleSmall,
                          ),
                        ),
                        CustomTextFormField(
                          controller: recipeName,
                          hint: "recipe_name_hint".tr(),
                          inputAction: TextInputAction.next,
                          fillColor: colorScheme(context).surface,
                          validator: (value) =>
                              Validation.fieldValidation(value, "recipe name"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "recipe_category".tr(),
                            style: textTheme(context).titleSmall,
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            recipeCategory.text = value;
                            setState(() {});
                          },
                          color: Colors.white,
                          itemBuilder: (context) => [
                            'dogs'.tr(),
                            'cats'.tr(),
                            'birds'.tr(),
                            'fish'.tr()
                          ]
                              .map((item) => PopupMenuItem(
                                    value: item,
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          child: IgnorePointer(
                            child: CustomTextFormField(
                              readOnly: true,
                              controller: recipeCategory,
                              hint: "category_name".tr(),
                              inputAction: TextInputAction.next,
                              fillColor: colorScheme(context).surface,
                              validator: (value) => Validation.fieldValidation(
                                  value, "Recipe Category"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "preparation_steps".tr(),
                            style: textTheme(context).titleSmall,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _editDescription(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorScheme(context).surface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: colorScheme(context).outlineVariant),
                            ),
                            child: recipeController.descriptionJson.isEmpty
                                ? Text(
                                    'preparation_steps_field'.tr(),
                                    style: textTheme(context)
                                        .bodyMedium
                                        ?.copyWith(
                                          color: colorScheme(context).outline,
                                        ),
                                  )
                                : quill.QuillEditor(
                                    controller: quill.QuillController(
                                      document: quill.Document.fromJson(
                                          jsonDecode(recipeController
                                              .descriptionJson)),
                                      selection: const TextSelection.collapsed(
                                          offset: 0),
                                    ),
                                    scrollController: ScrollController(),
                                    focusNode: FocusNode(),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: CustomButton(
                            onTap: () {
                              final overlay = context.loaderOverlay;
                              if (formKey.currentState?.validate() ?? false) {
                                if (recipeController.descriptionJson.isEmpty) {
                                  showSnackbar(
                                    message:
                                        'please_enter_preparation_steps'.tr(),
                                    isError: true,
                                  );
                                  return;
                                }

                                if (recipeController.pickedImages.isEmpty) {
                                  showSnackbar(
                                    message: "upload_picture_snackbar".tr(),
                                    isError: true,
                                  );
                                  return;
                                }
                                overlay.show();
                                log(recipeController.descriptionJson
                                    .toString());
                                String jsonString =
                                    recipeController.descriptionJson.toString();

                                // Decode the JSON
                                List<dynamic> jsonData = jsonDecode(jsonString);

                                // Extract and combine the "insert" strings
                                String extractedText = jsonData
                                    .map((item) => item['insert'] as String)
                                    .join(); // Joins all extracted strings together

                                log(extractedText);
                                recipeController.uploadRecipe(
                                    name: recipeName.text,
                                    category: recipeCategory.text,
                                    preparationSteps: extractedText,
                                    images: recipeController.pickedImages,
                                    onSuccess: (message) {
                                      recipeController.pickedImages.clear();
                                      recipeController.updateDescription('');
                                      overlay.hide();
                                      PersistentNavBarNavigator.pop(context);
                                    },
                                    onError: (error) {
                                      overlay.hide();
                                      showSnackbar(
                                          message: error, isError: true);
                                    },
                                    context: context);
                              } else {
                                showSnackbar(
                                  message:
                                      "Please fill in all required fields.",
                                  isError: true,
                                );
                              }
                            },
                            text: 'upload'.tr(),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
