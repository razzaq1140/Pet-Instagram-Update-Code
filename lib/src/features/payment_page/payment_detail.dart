import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import 'package:provider/provider.dart';

import '../../common/constants/global_variables.dart';
import '../../common/widget/custom_button.dart';
import '../../router/routes.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController cardNo = TextEditingController();
    TextEditingController expDate = TextEditingController();
    TextEditingController cvv = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Allows the screen to adjust when keyboard is shown
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'payment_confirmation'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
        actions: [
          SvgPicture.asset(
            AppIcons.cartIcon,
            colorFilter:
                ColorFilter.mode(colorScheme(context).primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 15),
          GestureDetector(
              onTap: () => context.pushNamed(AppRoute.notificationPage),
              child: SvgPicture.asset(AppIcons.notiIcon)),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to make content scrollable
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onPrimary, // White color for the inner container
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(
                          AppImages.cardImage), // Replace with your asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'enter_card_number'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 13),
                    CustomTextFormField(
                      hint: '2336 4545 4724 3541',
                      controller: cardNo,
                      // validator: Validation.cardNumberValidation,
                      filled: true,
                      inputAction: TextInputAction.next,
                      fillColor: colorScheme(context).surface,
                      focusBorderColor: colorScheme(context).surface,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'expiry_date'.tr(),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            hint: '12/29',
                            inputAction: TextInputAction.next,
                            controller: expDate,
                            // validator: Validation.expiryDateValidation,
                            filled: true,
                            fillColor: colorScheme(context).surface,
                            focusBorderColor: colorScheme(context).surface,
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'cvv'.tr(),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 15),
                          CustomTextFormField(
                            controller: cvv,
                            // validator: Validation.cvvValidation,
                            hint: '237',
                            inputAction: TextInputAction.next,
                            filled: true,
                            fillColor: colorScheme(context).surface,
                            focusBorderColor: colorScheme(context).surface,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Added extra spacing to make space for the button
                const SizedBox(height: 130),
                Consumer<ProductController>(
                  builder: (context, controller, child) {
                    final checkoutResponse = controller.checkoutResponse;

                    return CustomButton(
                      text: 'pay_now'.tr(),
                      onTap: () {
                        if (checkoutResponse != null) {
                          final orderId = checkoutResponse.orderId;

                          if (formKey.currentState!.validate()) {
                            controller.payment(
                              cardNumber: '4242424242424242',
                              expiryDate: "12/24",
                              cvv: '123',
                              orderId: orderId,
                            );

                            // if (controller.isLoading) {
                            //   return const Center(
                            //       child: CircularProgressIndicator());
                            // }

                            context.pushNamed(
                              AppRoute.orderconfirmation,
                              extra: false,
                            );
                          }
                        } else {
                          showSnackbar(message: 'No checkout response found.');
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
