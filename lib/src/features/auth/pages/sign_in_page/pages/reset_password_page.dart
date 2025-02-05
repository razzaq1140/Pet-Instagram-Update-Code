import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../controller/sign_in_controller.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final int otp;
  const ResetPasswordPage({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late SignInController _signInController;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    _signInController = Provider.of<SignInController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Reset Password",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                color: colorScheme(context).onSurface,
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Password",
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
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    var overlay = context.loaderOverlay;
                    overlay.show();
                    await _signInController.resetPassword(
                        email: widget.email,
                        otpCode: widget.otp,
                        password: newPassword.text.trim(),
                        onSuccess: (success) {
                          showSnackbar(message: success);
                          context.pop();
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
            ],
          ),
        ),
      ),
    );
  }
}
