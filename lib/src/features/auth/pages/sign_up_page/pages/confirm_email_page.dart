import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/features/auth/pages/sign_up_page/controller/sign_up_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';

import '../../../../../common/constants/global_variables.dart';
import '../../../../../common/widget/custom_button.dart';
import '../../../../../common/widget/custom_text_field.dart';

class ConfirmEmailPage extends StatelessWidget {
  final Map<String, String?> extra;
  const ConfirmEmailPage({super.key, required this.extra});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'confirmation'.tr(),
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
                  'confirm_email'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                Text(
                  // 'email_confirmation_prompt'.tr(),
                  'Enter the code sent to ${extra['email']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme(context).outline.withOpacity(0.7)),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: codeController,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'enter_code'.tr(),
                  validator: Validation.numberValidation,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomButton(
                    onTap: () {
                      final overlay = context.loaderOverlay;
                      if (formKey.currentState!.validate()) {
                        overlay.show();
                        log('email :${extra['email']}');
                        signUpController.verifyOtp(
                          email: '${extra['email']}',
                          otpCode: int.parse(codeController.text),
                          onSuccess: (message) {
                            context.pushNamed(
                              AppRoute.createNewPassword,
                              extra: {
                                'email': '${extra['email']}',
                                'otp': int.parse(codeController.text),
                              },
                            );
                            overlay.hide();
                            showSnackbar(message: message, isError: false);
                          },
                          onError: (error) {
                            overlay.hide();
                            showSnackbar(message: error, isError: true);
                          },
                          context: context,
                        );
                      }
                    },
                    text: 'confirm'.tr()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
