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

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "email".tr(),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: 20, color: colorScheme(context).onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: formKey,
          child: Consumer<SignUpController>(
              builder: (context, signUpController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'greeting'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                Text(
                  'enter_email'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 5),
                Text(
                  'verification_email_message'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme(context).outline.withOpacity(0.7)),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: emailController,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'email@official.com',
                  focusBorderColor:
                      colorScheme(context).onSurface.withOpacity(0.5),
                  validator: Validation.emailValidation,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomButton(
                    onTap: () async {
                      final overlay = context.loaderOverlay;
                      if (formKey.currentState!.validate()) {
                        overlay.show();
                        await signUpController.sendOpt(
                          email: emailController.text,
                          onSuccess: (message) {
                            context.pushNamed(
                              AppRoute.confirmationScreen,
                              extra: {
                                'email': emailController.text,
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
                    text: 'next'.tr()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
