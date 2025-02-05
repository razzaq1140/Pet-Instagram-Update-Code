import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/features/auth/pages/sign_up_page/controller/sign_up_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants/global_variables.dart';
import '../../../../../common/widget/custom_button.dart';
import '../../../../../common/widget/custom_text_field.dart';
import '../../../../../router/routes.dart';
import '../../../../_user_data/controllers/user_controller.dart';

class CreateNewPasswordPage extends StatelessWidget {
  final Map<String, Object?> extra;
  const CreateNewPasswordPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController newPassword = TextEditingController(text: '12345678');
    TextEditingController confirmPassword =
        TextEditingController(text: '12345678');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Confirmation",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: 20, color: colorScheme(context).onSurface),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: formKey,
          child: Consumer<SignUpController>(
              builder: (context, signUpController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'create_password'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 5),
                Text(
                  'password_instruction'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme(context).outline.withOpacity(0.7)),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: newPassword,
                  validator: (value) => Validation.passwordValidation(value),
                  fillColor: colorScheme(context).surface,
                  inputAction: TextInputAction.next,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'enter_password'.tr(),
                  focusBorderColor:
                      colorScheme(context).onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  controller: confirmPassword,
                  validator: (value) =>
                      Validation.confirmPassword(value, newPassword.text),
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'enter_confirm_password'.tr(),
                  focusBorderColor:
                      colorScheme(context).onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 20),
                CustomButton(
                    onTap: () {
                      final overlay = context.loaderOverlay;
                      if (formKey.currentState!.validate()) {
                        overlay.show();
                        signUpController.registerUser(
                          email: '${extra['email']}',
                          password: newPassword.text,
                          otpCode: int.parse('${extra['otp']}'),
                          onSuccess: (message) async {
                            final userController = Provider.of<UserController>(
                                context,
                                listen: false);
                            await userController.fetchUserData();
                            if (context.mounted) {
                              context.pushNamed(
                                AppRoute.userNamePage,
                              );
                            }
                            overlay.hide();
                            showSnackbar(message: message, isError: false);

                            log('email ${extra['email']}');
                            var value = int.parse('${extra['otp']}');
                            log('value $value');
                          },
                          onError: (error) {
                            overlay.hide();
                            showSnackbar(message: error, isError: true);
                          },
                          context: context,
                        );
                      }
                    },
                    text: 'next'.tr()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
