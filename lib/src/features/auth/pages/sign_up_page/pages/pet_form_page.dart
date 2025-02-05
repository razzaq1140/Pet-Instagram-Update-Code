import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/features/auth/pages/sign_up_page/controller/sign_up_controller.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants/global_variables.dart';
import '../../../../../common/widget/custom_button.dart';
import '../../../../../common/widget/custom_text_field.dart';
import '../../../../_user_data/controllers/user_controller.dart';

class PetFormPage extends StatefulWidget {
  final File? image;
  const PetFormPage({super.key, required this.image});

  @override
  PetFormPageState createState() => PetFormPageState();
}

class PetFormPageState extends State<PetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedPetType = 'dog'.tr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'abouts'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                color: colorScheme(context).onSurface,
              ),
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Consumer<SignUpController>(
                builder: (context, signUpController, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'tell_us_about_pet'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: colorScheme(context).onSurface),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'personalize_message'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme(context).outline.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'select_pet_type'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedPetType,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color:
                              colorScheme(context).onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    dropdownColor: colorScheme(context).surface,
                    style: TextStyle(
                      color: colorScheme(context).onSurface.withOpacity(0.5),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetType = newValue!;
                      });
                    },
                    items: <String>['dog'.tr(), 'cat'.tr(), 'bird'.tr()]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color:
                                colorScheme(context).onSurface.withOpacity(0.9),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: nameController,
                    validator: (value) =>
                        Validation.fieldValidation(value, 'Name'),
                    fillColor: colorScheme(context).surface,
                    inputAction: TextInputAction.next,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'Name',
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'breed'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: breedController,
                    validator: (value) =>
                        Validation.fieldValidation(value, "breed".tr()),
                    fillColor: colorScheme(context).surface,
                    inputAction: TextInputAction.next,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'breed_prompt'.tr(),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'ages'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: ageController,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'age_prompt'.tr(),
                    inputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) => Validation.ageValidation(value),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'weight'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: weightController,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'weight_prompt'.tr(),
                    validator: (value) => Validation.weightValidation(value),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme(context).onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: aboutController,
                    fillColor: colorScheme(context).surface,
                    borderColor:
                        colorScheme(context).onSurface.withOpacity(0.5),
                    hint: 'About',
                    maxline: 4,
                    validator: (value) =>
                        Validation.fieldValidation(value, 'About'),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    onTap: () {
                      final overlay = context.loaderOverlay;
                      if (_formKey.currentState!.validate()) {
                        overlay.show();
                        try {
                          signUpController.setUserAbout(
                            name: nameController.text,
                            dogType: selectedPetType,
                            breed: breedController.text,
                            age: int.parse(ageController.text.trim()),
                            weight: double.parse(weightController.text.trim()),
                            about: aboutController.text,
                            onSuccess: (message) async {
                              final userController =
                                  Provider.of<UserController>(context,
                                      listen: false);
                              await userController.fetchUserData();
                              if (context.mounted) {
                                MyAppRouter.clearAndNavigate(
                                    context, AppRoute.membershipPage);
                              }
                              overlay.hide();
                            },
                            onError: (error) {
                              overlay.hide();
                              showSnackbar(message: error, isError: true);
                            },
                            context: context,
                          );
                        } catch (e) {
                          overlay.hide();

                          if (e is FormatException) {
                            showSnackbar(
                                message:
                                    'Please enter valid numeric values for age and weight.',
                                isError: true);
                          } else {
                            showSnackbar(
                                message: 'An unexpected error occurred.',
                                isError: true);
                          }
                        }
                      }
                    },
                    text: 'confirm'.tr(),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
