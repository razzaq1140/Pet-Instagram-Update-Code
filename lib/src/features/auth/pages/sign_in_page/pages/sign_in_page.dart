import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/features/auth/pages/sign_in_page/controller/sign_in_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants/global_variables.dart';
import '../../../../../common/widget/custom_button.dart';
import '../../../../../common/widget/custom_text_field.dart';
import '../../../../_user_data/controllers/user_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pushNamed(AppRoute.welcomeScreen);
          },
        ),
        title: Text(
          "sign_in".tr(),
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
          child: Consumer<SignInController>(
              builder: (context, signInController, child) {
            return AutofillGroup(
              child: Column(
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
                    textAlign: TextAlign.left,
                    'login_message'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: colorScheme(context).onSurface),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    autoFillHints: const [AutofillHints.email],
                    controller: emailController,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'email_placeholder'.tr(),
                    validator: Validation.emailOrUsernameValidation,
                    inputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    focusBorderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    autoFillHints: const [AutofillHints.password],
                    controller: passwordController,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'password_placeholder'.tr(),
                    inputAction: TextInputAction.next,
                    // validator: Validation.passwordValidation,
                    focusBorderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            signInController.toggleRememberMe();
                          },
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: signInController.rememberMe
                                        ? colorScheme(context).primary
                                        : colorScheme(context).surface,
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      width: 1,
                                      color: signInController.rememberMe
                                          ? colorScheme(context).primary
                                          : colorScheme(context).outline,
                                    )),
                                child: Icon(Icons.check,
                                    size: 12,
                                    color: colorScheme(context).surface),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  "Remember password",
                                  style:
                                      textTheme(context).bodyMedium?.copyWith(
                                            color: colorScheme(context)
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoute.forgetPasswordPage);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context)
                                      .onSurface
                                      .withOpacity(0.5),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      onTap: () async {
                        final overlay = context.loaderOverlay;
                        if (formKey.currentState!.validate()) {
                          overlay.show();
                          signInController.rememberMe
                              ? TextInput.finishAutofillContext()
                              : null;
                          signInController.loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                              onSuccess: (message) async {
                                final userController =
                                    Provider.of<UserController>(context,
                                        listen: false);
                                await userController.fetchUserData();
                                overlay.hide();
                                if (context.mounted) {
                                  context.pushNamed(
                                    AppRoute.navigationBar,
                                  );
                                }
                              },
                              onError: (error) {
                                overlay.hide();
                                showSnackbar(message: error, isError: true);
                              },
                              context: context);
                        }
                      },
                      text: 'next'.tr()),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
