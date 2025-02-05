// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/settings/controller/settings_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';

class BussinessProfilePage extends StatefulWidget {
  const BussinessProfilePage({super.key});

  @override
  State<BussinessProfilePage> createState() => _BussinessProfilePageState();
}

class _BussinessProfilePageState extends State<BussinessProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController businessNameTEC = TextEditingController();
  final TextEditingController bioTEC = TextEditingController();
  final TextEditingController ownerNameTEC = TextEditingController();

  // XFile? selectedImage;

  // Future<void> _pickImage() async {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: <Widget>[
  //             ListTile(
  //               leading: const Icon(Icons.photo_library),
  //               title: Text('Pick from Gallery'.tr()),
  //               onTap: () {
  //                 pickImageFromGallery();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.photo_camera),
  //               title: Text('capture_from_gallery'.tr()),
  //               onTap: () {
  //                 pickImageFromCamera();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Function to pick an image from the gallery
  // Future<void> pickImageFromGallery() async {
  //   try {
  //     await ImagePickerHelper.pickImageFromGallery().then((image) {
  //       if (image != null) {
  //         setState(() {
  //           selectedImage = image;
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     showSnackbar(
  //       message: 'failed_to_pick_images'.tr(),
  //       isError: true,
  //     );
  //   }
  // }

  // Function to capture an image from the camera
  // Future<void> pickImageFromCamera() async {
  //   try {
  //     await ImagePickerHelper.pickImageFromCamera().then((image) {
  //       if (image != null) {
  //         setState(() {
  //           selectedImage = image;
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     showSnackbar(
  //       message: 'failed_to_capture_image'.tr(),
  //       isError: true,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<SettingsController>(
              builder: (context, controller, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      //   textAlign: TextAlign.center,
                      'Complete Your profile'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme(context).onSurface,
                          ),
                    ),
                  ),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Add a profile photo, business name\nbio and website to let people who you are.'
                          .tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                colorScheme(context).onSurface.withOpacity(0.5),
                          ),
                    ),
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor:
                                colorScheme(context).primary.withOpacity(0.2),
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : null,
                            child: controller.image == null
                                ? Icon(Icons.pets,
                                    size: 80,
                                    color: colorScheme(context)
                                        .surface
                                        .withOpacity(0.8))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: GestureDetector(
                            onTap: controller.pickImage,
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
                  Text('Business Name'.tr(),
                      style: textTheme(context).titleSmall),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: businessNameTEC,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'Enter business name',
                    inputAction: TextInputAction.next,
                    validator: (value) =>
                        Validation.fieldValidation(value, "business name".tr()),
                    focusBorderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Add Bio'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: bioTEC,
                    validator: (value) =>
                        Validation.fieldValidation(value, "Bio".tr()),
                    fillColor: colorScheme(context).surface,
                    inputAction: TextInputAction.next,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'Enter Bio'.tr(),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Owner Name'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: ownerNameTEC,
                    inputAction: TextInputAction.next,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'Enter owner name'.tr(),
                    validator: (value) =>
                        Validation.fieldValidation(value, "Owner Name".tr()),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(
                    height: 70,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (controller.image == null) {
                        showSnackbar(
                            message: "upload_image_snackbar".tr(),
                            isError: true);
                      } else if (_formKey.currentState!.validate()) {
                        final overlay = context.loaderOverlay;

                        await controller
                            .setupSellerCenter(
                          storeName: businessNameTEC.text,
                          ownerName: ownerNameTEC.text,
                          storeDetails: bioTEC.text,
                        )
                            .whenComplete(
                          () {
                            controller.sellerSetupCenterLogo(
                              context: context,
                              logo: controller.image!,
                              onSuccess: (message) {
                                overlay.hide();
                                context.pushNamed(AppRoute.navigationBar);
                              },
                              onError: (error) {
                                overlay.hide();
                                showSnackbar(message: error, isError: true);
                              },
                            );
                          },
                        );
                      } else {
                        showSnackbar(
                            message: "upload_before_confirming".tr(),
                            isError: true);
                      }

                      // controller.setupSellerCenter(
                      //   storeName: businessNameTEC.text,
                      //   ownerName: ownerNameTEC.text,
                      //   storeDetails: bioTEC.text,
                      // );

                      // // showSnackbar(message: 'Seller center is being setup');

                      // // context.pushNamed(AppRoute.addProduct);
                      // context.pushNamed(AppRoute.navigationBar);

                      // Save account details and mark the seller as onboarded
                      // await SharedPrefHelper.saveBool(
                      //     'isSellerOnboarded', true);
                      // onAccountCreated();
                      // Navigate to the add product screen
                      //    context.pushNamed(AppRoute.addProduct);
                    },
                    text: 'Save & Continue'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
