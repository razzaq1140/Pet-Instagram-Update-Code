// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '/src/common/constants/app_images.dart';
// import '/src/common/constants/global_variables.dart';
// import '/src/common/utils/validation.dart';
// import '/src/common/widget/custom_button.dart';
// import '/src/common/widget/custom_text_field.dart';

// class UploadIngredientPage extends StatefulWidget {
//   const UploadIngredientPage({super.key});

//   @override
//   State<UploadIngredientPage> createState() => _UploadIngredientPageState();
// }

// class _UploadIngredientPageState extends State<UploadIngredientPage> {
//   GlobalKey<FormState> formKey = GlobalKey();
//   TextEditingController productName = TextEditingController();
//   TextEditingController price = TextEditingController();
//   TextEditingController quantity = TextEditingController();
//   TextEditingController description = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'upload_product'.tr(),
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                           fontSize: 20, color: colorScheme(context).onSurface),
//                     ),
//                     Text(
//                       ' (${'ingredients'.tr})',
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                           fontSize: 20,
//                           color:
//                               colorScheme(context).onSurface.withOpacity(0.4)),
//                     ),
//                     const Spacer(),
//                     SvgPicture.asset(AppIcons.notiIcon),
//                     const SizedBox(width: 8),
//                     SvgPicture.asset(AppIcons.chatIcon),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: colorScheme(context).onPrimary,
//                     borderRadius: const BorderRadius.all(Radius.circular(6)),
//                     border: Border.all(
//                         color: colorScheme(context).outlineVariant, width: 1),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "add_product".tr(),
//                           style: textTheme(context)
//                               .headlineMedium
//                               ?.copyWith(fontSize: 24),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "product_name".tr(),
//                           style: textTheme(context).titleSmall,
//                         ),
//                       ),
//                       CustomTextFormField(
//                         controller: productName,
//                         hint: "product_name_hint".tr(),
//                         inputAction: TextInputAction.next,

//                         keyboardType: TextInputType.name,
//                         validator: (value) => Validation.fieldValidation(
//                             value, "product_name_field".tr()),
//                         fillColor: colorScheme(context).surface,
//                         // validationType: ValidationType.name,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "price".tr(),
//                           style: textTheme(context).titleSmall,
//                         ),
//                       ),
//                       CustomTextFormField(
//                         controller: price,
//                         hint: "150\$",
//                         validator: Validation.numberValidation,
//                         inputAction: TextInputAction.next,
//                         fillColor: colorScheme(context).surface,
//                         // validationType: ValidationType.number,
//                         keyboardType: const TextInputType.numberWithOptions(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "quantity".tr(),
//                           style: textTheme(context).titleSmall,
//                         ),
//                       ),
//                       CustomTextFormField(
//                         controller: quantity,
//                         hint: "50",
//                         validator: Validation.numberValidation,
//                         inputAction: TextInputAction.next,
//                         fillColor: colorScheme(context).surface,
//                         // validationType: ValidationType.number,
//                         keyboardType: const TextInputType.numberWithOptions(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "description".tr(),
//                           style: textTheme(context).titleSmall,
//                         ),
//                       ),
//                       CustomTextFormField(
//                         controller: description,
//                         hint:
//                             "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
//                         validator: (value) => Validation.fieldValidation(
//                             value, "description".tr()),
//                         fillColor: colorScheme(context).surface,
//                         keyboardType: TextInputType.multiline,
//                         // validationType: ValidationType.name,
//                         maxline: 5,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Center(
//                           child: Text(
//                             "add_more_ingredients".tr(),
//                             style: textTheme(context)
//                                 .titleSmall
//                                 ?.copyWith(color: colorScheme(context).primary),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: CustomButton(
//                             onTap: () {
//                               if (formKey.currentState!.validate()) {
//                                 // context.pushNamed(AppRoute.navigationBar);
//                                 // Assuming index 3 is Seller Center
//                                 // context.pushReplacement(
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) =>
//                                 //         CustomBottomNavigationBar(),
//                                 //     settings: RouteSettings(
//                                 //         arguments:
//                                 //             3), // Pass the index for Seller Center
//                                 //   ),
//                                 // );
//                               }
//                             },
//                             text: 'upload'.tr(),
//                           )
//                           //    CustomButton(
//                           //       onTap: () {
//                           //         formKey.currentState!.validate();
//                           //         context.pushNamed(AppRoute.navigationBar);
//                           //       },
//                           //       text: 'upload'.tr()),
//                           )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
