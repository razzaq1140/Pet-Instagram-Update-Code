import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/validation.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/notification/page/notification_page.dart';

class AddNewAddresPage extends StatefulWidget {
  const AddNewAddresPage({super.key});

  @override
  State<AddNewAddresPage> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<AddNewAddresPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController fullName = TextEditingController();
  TextEditingController streetAdrress = TextEditingController();
  TextEditingController destinationType = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  String countryValue = ''; // This will store the selected country name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'address'.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 20, color: colorScheme(context).onSurface),
                    ),
                    const Spacer(),
                    // ignore: deprecated_member_use
                    SvgPicture.asset(
                      AppIcons.cartIcon,
                      colorFilter: ColorFilter.mode(
                          colorScheme(context).primary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: const NotificationPage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade);
                        },
                        child: SvgPicture.asset(AppIcons.notiIcon)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(
                        color: colorScheme(context).outlineVariant, width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "enter_shipping_address".tr(),
                          style: textTheme(context).titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "select_country".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              flagSize: 25,
                              backgroundColor: colorScheme(context).surface,
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: colorScheme(context).outline,
                              ),
                              bottomSheetHeight:
                                  500, // Optional. Country list modal height
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              inputDecoration: InputDecoration(
                                hintText: 'search'.tr(),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            onSelect: (Country country) {
                              setState(() {
                                countryValue =
                                    country.name; // Store selected country name
                              });
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: colorScheme(context).surface),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(countryValue.isNotEmpty
                                  ? countryValue
                                  : "country".tr()),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "full_name".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        controller: fullName,
                        hint: "name".tr(),
                        validator: (value) => Validation.fieldValidation(
                            value, "full_name_field".tr()),
                        fillColor: colorScheme(context).surface,
                        inputAction: TextInputAction.next,
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "street_address".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        controller: streetAdrress,
                        hint: "address".tr(),
                        inputAction: TextInputAction.next,
                        fillColor: colorScheme(context).surface,
                        validator: (value) => Validation.fieldValidation(
                            value, "street_address_field".tr()),
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "apt_suits_other".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        controller: destinationType,
                        hint: "apt".tr(),
                        inputAction: TextInputAction.next,
                        fillColor: colorScheme(context).surface,
                        validator: (value) => Validation.fieldValidation(
                            value, "destination_type".tr()),
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "city".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        hint: "city".tr(),
                        inputAction: TextInputAction.next,
                        controller: city,
                        fillColor: colorScheme(context).surface,
                        validator: (value) =>
                            Validation.fieldValidation(value, "city".tr()),
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "province".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        hint: "province".tr(),
                        inputAction: TextInputAction.next,
                        controller: province,
                        validator: (value) =>
                            Validation.fieldValidation(value, "province".tr()),
                        fillColor: colorScheme(context).surface,
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "postal_code".tr(),
                          style: textTheme(context).titleSmall,
                        ),
                      ),
                      CustomTextFormField(
                        hint: "postal_code".tr(),
                        inputAction: TextInputAction.next,
                        controller: postalCode,
                        keyboardType: TextInputType.number,
                        validator: Validation.numberValidation,
                        fillColor: colorScheme(context).surface,
                        // validationType: ValidationType.name,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomButton(
                            onTap: () {
                              if (countryValue.isEmpty) {
                                showSnackbar(
                                    message: "please_select_country".tr(),
                                    isError: true);
                              } else if (countryValue.isNotEmpty &&
                                  formKey.currentState!.validate()) {
                                String newAddress =
                                    '${streetAdrress.text}, ${city.text}, ${province.text}, ${postalCode.text}, $countryValue';

                                // Return the new address to the previous screen
                                Navigator.pop(context, newAddress);
                              }
                            },
                            text: 'checkout'.tr()),
                      )
                    ],
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
