import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/widget/custom_button.dart';
import '/src/features/auth/pages/sign_up_page/controller/sign_up_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants/app_images.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});
  @override
  UploadImagePageState createState() => UploadImagePageState();
}

class UploadImagePageState extends State<UploadImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "upload".tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                color: colorScheme(context).onSurface,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              MyAppRouter.clearAndNavigate(context, AppRoute.membershipPage);
            },
            child: Text(
              'skip'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme(context).onSurface.withOpacity(0.5),
                  ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<SignUpController>(
            builder: (context, signUpController, child) {
          return Column(
            children: [
              Text(
                "upload_pet_image".tr(),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: colorScheme(context).onSurface),
              ),
              const SizedBox(height: 10),
              Text(
                "personalize_message".tr(),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme(context).outline.withOpacity(0.7)),
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor:
                          colorScheme(context).primary.withOpacity(0.2),
                      backgroundImage: signUpController.image != null
                          ? FileImage(signUpController.image!)
                          : null,
                      child: signUpController.image == null
                          ? Icon(Icons.pets,
                              size: 80,
                              color:
                                  colorScheme(context).surface.withOpacity(0.8))
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        signUpController.pickImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme(context).surface,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  colorScheme(context).outline.withOpacity(0.2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(AppIcons.camera, height: 32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("click_upload".tr()),
              const SizedBox(height: 30),
              CustomButton(
                  onTap: () {
                    final overlay = context.loaderOverlay;

                    if (signUpController.image != null) {
                      overlay.show();

                      signUpController.setUserProfileImage(
                        context: context,
                        image: signUpController.image!,
                        onSuccess: (message) {
                          context.pushNamed(AppRoute.petFormPage);
                          overlay.hide();
                        },
                        onError: (error) {
                          overlay.hide();
                          showSnackbar(message: error, isError: true);
                        },
                      );
                    } else {
                      showSnackbar(
                          message: "upload_before_confirming".tr(),
                          isError: true);
                    }
                  },
                  text: 'confirm'.tr()),
            ],
          );
        }),
      ),
    );
  }
}
