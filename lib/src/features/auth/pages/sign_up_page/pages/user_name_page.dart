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

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController userName = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'username'.tr(),
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
                  // 'choose_username'.tr(),
                  'Username',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: userName,
                  validator: (value) =>
                      Validation.fieldValidation(value, "username"),
                  fillColor: colorScheme(context).surface,
                  borderColor: colorScheme(context).onSurface.withOpacity(0.5),
                  hint: 'Whiskers Pet',
                  focusBorderColor:
                      colorScheme(context).onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 20),
                CustomButton(
                    onTap: () async {
                      final overlay = context.loaderOverlay;
                      if (formKey.currentState!.validate()) {
                        overlay.show();
                        await Future.delayed(const Duration(seconds: 1));
                        if (context.mounted) {
                          Future.delayed(const Duration(seconds: 1));
                          signUpController.userName(
                            context: context,
                            name: userName.text,
                            onSuccess: (message) {
                              context.pushNamed(AppRoute.petImagePage);
                              overlay.hide();
                            },
                            onError: (error) {
                              overlay.hide();
                              showSnackbar(message: error, isError: true);
                            },
                          );
                        }
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
