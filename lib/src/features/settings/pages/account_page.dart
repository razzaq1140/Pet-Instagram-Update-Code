import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/image_picker_helper.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/_user_data/controllers/user_controller.dart';
import '/src/features/settings/controller/settings_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/shared_preferences_helper.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  String selectedPetType = 'dog'.tr();
  XFile? selectedImage;
  late SettingsController controller;
  late UserController userController;

  @override
  void initState() {
    setInitialValue();
    super.initState();
  }

  setInitialValue() {
    userController = Provider.of<UserController>(context, listen: false);
    if (userController.user != null) {
      usernameController.text = userController.user!.username;
      nameController.text = userController.user!.name;
      breedController.text = userController.user!.breed;
      ageController.text = userController.user!.age.toString();
      weightController.text = userController.user!.weight.toInt().toString();
      aboutController.text = userController.user!.about;
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Pick from Gallery'.tr()),
                onTap: () {
                  pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('capture_from_gallery'.tr()),
                onTap: () {
                  pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      await ImagePickerHelper.pickImageFromGallery().then((image) {
        if (image != null) {
          setState(() {
            selectedImage = image;
          });
        }
      });
    } catch (e) {
      showSnackbar(
        message: 'failed_to_pick_images'.tr(),
        isError: true,
      );
    }
  }

  // Function to capture an image from the camera
  Future<void> pickImageFromCamera() async {
    try {
      await ImagePickerHelper.pickImageFromCamera().then((image) {
        if (image != null) {
          setState(() {
            selectedImage = image;
          });
        }
      });
    } catch (e) {
      showSnackbar(
        message: 'failed_to_capture_image'.tr(),
        isError: true,
      );
    }
  }

  // Method to handle account creation completion
  void onAccountCreated() async {
    // Mark that the user has completed the seller onboarding
    await SharedPrefHelper.saveBool(isSellerOnboardedText, true);
    if (mounted) {
      // Navigate to the Add Product Page
      context.pushNamed(AppRoute.addProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Text("account".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<SettingsController>(
              builder: (context, settingsController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'change_image'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              colorScheme(context).primary.withOpacity(0.2),
                          backgroundImage: selectedImage != null
                              ? FileImage(File(selectedImage!.path))
                              : null,
                          child: ClipOval(
                            child: Image(
                              height: 120,
                              width: 120,
                              image: selectedImage != null
                                  ? FileImage(File(selectedImage!.path))
                                  : NetworkImage(
                                      userController.user!.profileImage),
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: colorScheme(context).surface,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                'assets/images/splashdog.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: colorScheme(context).surface,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme(context)
                                      .outline
                                      .withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child:
                                SvgPicture.asset(AppIcons.camera, height: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('user_name'.tr(), style: textTheme(context).titleSmall),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: usernameController,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'Whiskers Pet',
                  inputAction: TextInputAction.next,
                  validator: (value) =>
                      Validation.fieldValidation(value, "name".tr()),
                  focusBorderColor:
                      colorScheme(context).onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 15),
                Text(
                  'select_pet_type'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedPetType,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: colorScheme(context).onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  dropdownColor: colorScheme(context).surface,
                  style: TextStyle(
                    color: colorScheme(context).onSurface.withOpacity(0.5),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPetType = newValue!;
                    });
                  },
                  items: <String>['dog'.tr(), 'cat'.tr(), 'bird'.tr()]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color:
                              colorScheme(context).onSurface.withOpacity(0.9),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: nameController,
                  validator: (value) =>
                      Validation.fieldValidation(value, 'Name'),
                  fillColor: colorScheme(context).surface,
                  inputAction: TextInputAction.next,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'Name',
                ),
                const SizedBox(height: 15),
                Text(
                  'breed'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: breedController,
                  validator: (value) =>
                      Validation.fieldValidation(value, "breed".tr()),
                  fillColor: colorScheme(context).surface,
                  inputAction: TextInputAction.next,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'breed_hint'.tr(),
                ),
                const SizedBox(height: 15),
                Text(
                  'age'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: ageController,
                  inputAction: TextInputAction.next,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'age_hint'.tr(),
                  validator: Validation.numberValidation,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                Text(
                  'weight'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: weightController,
                  inputAction: TextInputAction.next,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'weight_hint'.tr(),
                  validator: Validation.numberValidation,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme(context).onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: aboutController,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'About',
                  maxline: 4,
                  validator: (value) =>
                      Validation.fieldValidation(value, 'About'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                // CustomButton(
                //   onTap: () {
                //     if (selectedImage == null) {
                //       showSnackbar(message: "upload_image_snackbar".tr(),isError: true);
                //     } if (_formKey.currentState!.validate()) {
                //       // Proceed with saving if form is valid and image is uploaded
                //       // Perform save operation here
                //     }
                //   },
                //   text: 'save'.tr(),
                // ),
                CustomButton(
                  onTap: () async {
                    final overlay = context.loaderOverlay;
                    if (_formKey.currentState!.validate()) {
                      overlay.show();
                      try {
                        userController.updateUserAbout(
                          username: usernameController.text,
                          name: nameController.text,
                          dogType: selectedPetType,
                          breed: breedController.text,
                          age: int.parse(ageController.text.trim()),
                          weight: double.parse(weightController.text.trim()),
                          about: aboutController.text,
                          image: selectedImage == null
                              ? null
                              : File(selectedImage!.path),
                          onSuccess: (message) {
                            context.pop();
                            overlay.hide();
                          },
                          onError: (error) {
                            overlay.hide();
                            showSnackbar(message: error, isError: true);
                          },
                          context: context,
                        );
                      } catch (e) {
                        overlay.hide();

                        if (e is FormatException) {
                          showSnackbar(
                              message:
                                  'Please enter valid numeric values for age and weight.',
                              isError: true);
                        } else {
                          showSnackbar(
                              message: 'An unexpected error occurred.',
                              isError: true);
                        }
                      }

                      // Save account details and mark the seller as onboarded
                      // await SharedPrefHelper.saveBool(
                      //     'isSellerOnboarded', true);
                      // onAccountCreated();
                      // Navigate to the add product screen
                      //    context.pushNamed(AppRoute.addProduct);
                    }
                  },
                  text: 'save'.tr(),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
