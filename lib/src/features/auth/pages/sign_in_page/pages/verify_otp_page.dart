import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../../../../common/utils/custom_snackbar.dart';
import '../../../../../common/utils/validation.dart';
import '../../../../../common/widget/custom_text_field.dart';
import '../controller/sign_in_controller.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_button.dart';
import '/src/router/routes.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({super.key, required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late SignInController _signInController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
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
          "Verify Email",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 20,
              color: colorScheme(context).onSurface // Customize color

              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 80,
                  color: colorScheme(context).onSurface,
                ),
                const SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "Verify your OTP",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "We have just sent an OTP to your email. Please check your email",
                    textAlign: TextAlign.center,
                    style: textTheme(context).bodyLarge?.copyWith(
                        color: colorScheme(context).onSurface.withOpacity(0.6)),
                  ),
                ),
                CustomTextFormField(
                  controller: codeController,
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'enter_code'.tr(),
                  validator: Validation.numberValidation,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.next,
                ),
                const SizedBox(height: 40),
                CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        var overlay = context.loaderOverlay;
                        overlay.show();
                        await _signInController.verifyOtp(
                            email: widget.email,
                            otpCode: int.parse(codeController.text.trim()),
                            onSuccess: (success) {
                              showSnackbar(message: success);
                              MyAppRouter.popUntilAndNavigate(context,
                                  until: 2,
                                  name: AppRoute.resetPasswordPage,
                                  extra: {
                                    'otp':
                                        int.parse(codeController.text.trim()),
                                    'email': widget.email,
                                  });
                            },
                            onError: (error) {
                              showSnackbar(message: error, isError: true);
                            },
                            context: context);
                        overlay.hide();
                      }
                    },
                    text: "Verify"),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    var overlay = context.loaderOverlay;
                    overlay.show();
                    await _signInController.sendPasswordResetOtp(
                        email: widget.email,
                        onSuccess: (success) {
                          showSnackbar(message: success);
                        },
                        onError: (error) {
                          showSnackbar(message: error, isError: true);
                        },
                        context: context);
                    overlay.hide();
                  },
                  child: Text(
                    "Resend Otp",
                    style: textTheme(context)
                        .titleSmall
                        ?.copyWith(color: colorScheme(context).primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
