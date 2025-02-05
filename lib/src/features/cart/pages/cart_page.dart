// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/widget/custom_button.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/utils/custom_snackbar.dart';
import '../../add_address/pages/address_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  PaymentCheckOutScreenState createState() => PaymentCheckOutScreenState();
}

class PaymentCheckOutScreenState extends State<CartPage> {
  final List<String> addresses = [
    'asjkdhkashdlashdkashdklashdkashdjkasdjkashdjkashdjk'
  ];
  String selectedAddress = "";
  bool isExpanded = false;
  late TextEditingController promoCodeTEC;
  late ProductController productController;

  // void _incrementQuantity(int index, ProductController controller) {
  //   var cartItem = controller.cartResponse!.data[index];
  //   setState(() {
  //     cartItem.quantity++;
  //   });
  // }

  void _incrementQuantity({
    required int index,
    required ProductController controller,
  }) {
    var cartItem = controller.cartResponse!.data[index];

    cartItem.quantity++;
    controller
        .updateCartItem(
      itemId: cartItem.id,
      quantity: cartItem.quantity,
    )
        .whenComplete(
      () {
        productController.fetchCartSummary();
      },
    );
  }

  void _decrementQuantity({
    required int index,
    required ProductController controller,
  }) {
    var cartItem = controller.cartResponse!.data[index];

    cartItem.quantity--;
    controller
        .updateCartItem(
      itemId: cartItem.id,
      quantity: cartItem.quantity,
    )
        .whenComplete(
      () {
        productController.fetchCartSummary();
      },
    );
  }
  // void _decrementQuantity(int index, ProductController controller) {
  //   final cartItem = controller.cartResponse!.data[index];
  //   if (cartItem.quantity > 1) {
  //     setState(() {
  //       cartItem.quantity--;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    productController = Provider.of(context, listen: false);
    promoCodeTEC = TextEditingController();

    Timer(
      const Duration(milliseconds: 20),
      () async {
        await productController.fetchCart();
        await productController.fetchCartSummary();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'cart'.tr(),
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
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: const NotificationPage(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade);
              },
              // onTap: () => context.pushNamed(AppRoute.notificationPage),
              child: SvgPicture.asset(AppIcons.notiIcon)),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProductController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.cartResponse == null ||
                controller.cartResponse!.data.isEmpty) {
              return const Center(child: Text('No items in the cart.'));
            }

            final cartItems = controller.cartResponse!.data;

            return Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.4)),
                  ),
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme(context).onPrimary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.product.images.isNotEmpty
                                        ? item.product.images[0]
                                        : 'https://via.placeholder.com/150',
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.product.price}\$',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary, // Counter background color
                                      borderRadius: BorderRadius.circular(
                                          24), // Rounded counter container
                                    ),
                                    child: Row(children: [
                                      // Decrement Button
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color:
                                              colorScheme(context).onSecondary,
                                          //  Colors
                                          //     .white, // Icon color inside counter
                                          size: 16, // Icon size
                                        ),
                                        onPressed: () => _decrementQuantity(
                                          index: index,
                                          controller: controller,
                                        ),
                                      ),

                                      // Quantity Display
                                      Text(
                                        item.quantity
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                          color:
                                              colorScheme(context).onSecondary,
                                          // Quantity text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Increment Button
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color:
                                              colorScheme(context).onSecondary,
                                          // Icon color inside counter
                                          size: 16, // Icon size
                                        ),
                                        onPressed: () => _incrementQuantity(
                                          index: index,
                                          controller: controller,
                                        ),
                                      )
                                    ]))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "select_shipping_address".tr(),
                      style: textTheme(context).titleMedium,
                    ),
                    TextButton(
                        onPressed: () async {
                          final newAddress = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddNewAddresPage()),
                          );
                          if (newAddress != null) {
                            setState(() {
                              addresses.add(newAddress);
                              selectedAddress = newAddress;
                            });
                          }

                          // PersistentNavBarNavigator.pushNewScreen(context,
                          //     screen: const AddNewAddresPage(),
                          //     withNavBar: true,
                          //     pageTransitionAnimation:
                          //         PageTransitionAnimation.fade);
                        },
                        child: Text(
                          "add_new".tr(),
                          style: textTheme(context).titleSmall?.copyWith(
                              color: colorScheme(context).primary,
                              fontWeight: FontWeight.w400),
                        ))
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.2)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                selectedAddress,
                                style: textTheme(context).titleSmall?.copyWith(
                                    color: AppColor.hintText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: colorScheme(context).primary,
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Column(
                          children: addresses.map((address) {
                            return RadioListTile<String>(
                              value: address,
                              groupValue: selectedAddress,
                              title: Text(
                                address,
                                style: textTheme(context)
                                    .bodyMedium
                                    ?.copyWith(color: AppColor.hintText),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedAddress = value!;
                                  isExpanded = false; // Collapse on selection
                                });
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: promoCodeTEC,
                  hint: 'enter_promo_code'.tr(),
                  filled: true,
                  borderColor: colorScheme(context).outline.withOpacity(0.2),
                  fillColor: colorScheme(context).onPrimary,
                  focusBorderColor: colorScheme(context).surface,
                  keyboardType: TextInputType.number,
                  suffixConstraints:
                      const BoxConstraints(maxHeight: 40, maxWidth: 120),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CustomButton(
                      onTap: () {
                        showSnackbar(
                          message: 'Promo code applied successfully!',
                          backgroundColor: AppColor.appGreen,
                          label: 'UNDO',
                        );
                      },
                      text: 'apply'.tr(),
                      textSize: 14,
                      borderRadius: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.2)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'payment'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'subtotal'.tr(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                          Text(
                            controller.cartSummary!.data.subtotal.toString(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: AppColor.dividerColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'discount'.tr(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                          Text(
                            controller.cartSummary!.data.discount.toString(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: AppColor.dividerColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'shipping'.tr(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                          Text(
                            controller.cartSummary!.data.shipping.toString(),
                            style: const TextStyle(
                              color: AppColor.hintText,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: AppColor.dividerColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.cartSummary!.data.total.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                    onTap: () async {
                      if (selectedAddress.isEmpty) {
                        showSnackbar(message: 'Add address');
                      } else {
                        await controller.checkOut(
                          address: selectedAddress,
                          promoCode: promoCodeTEC.text,
                        );

                        if (controller.checkoutResponse != null) {
                          context.pushNamed(
                            AppRoute.paymentDetail,
                          );
                        } else {
                          showSnackbar(message: 'Failed to process checkout.');
                        }
                      }
                    },
                    text: 'check_out'.tr()),
              ],
            );
          },
        ),
      ),
    );
  }
}
