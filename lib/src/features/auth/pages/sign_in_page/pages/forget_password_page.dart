import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pet_project/src/common/utils/custom_snackbar.dart';
import 'package:pet_project/src/features/auth/pages/sign_in_page/controller/sign_in_controller.dart';
import 'package:provider/provider.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/router/routes.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late SignInController _signInController;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    _signInController = Provider.of<SignInController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 20,
              color: colorScheme(context).onSurface // Customize color

              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'enter_email'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: colorScheme(context).onSurface),
              ),
              // const SizedBox(height:),

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
                  if (formKey.currentState!.validate()) {
                    var overlay = context.loaderOverlay;
                    overlay.show();
                    await _signInController.sendPasswordResetOtp(
                        email: emailController.text.trim(),
                        onSuccess: (success) {
                          showSnackbar(message: success);
                          context.pushNamed(AppRoute.verifyOtpPage,
                              extra: emailController.text.trim());
                        },
                        onError: (error) {
                          showSnackbar(message: error, isError: true);
                        },
                        context: context);
                    overlay.hide();
                  }
                },
                text: 'next'.tr(),
              ),
              const SizedBox(
                height: 20,
              ),
              // const Text("Back to Login")
            ],
          ),
        ),
      ),
    );
  }
}
