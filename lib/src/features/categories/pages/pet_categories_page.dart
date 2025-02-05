import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import '/src/features/cart/pages/cart_page.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_text_field.dart';
import '../../../common/widget/product_card.dart';

class PetCategoriesPage extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final TextEditingController searchController;

  const PetCategoriesPage(
      {super.key,
      required this.searchController,
      required this.categoryName,
      required this.categoryId});

  @override
  State<PetCategoriesPage> createState() => _PetCategoriesPageState();
}

class _PetCategoriesPageState extends State<PetCategoriesPage> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    final productController =
        Provider.of<ProductController>(context, listen: false);

    Timer(
      const Duration(milliseconds: 20),
      () {
        productController.productsByCatagories(categoryId: widget.categoryId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
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
                                child: const Icon(Icons.arrow_back)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.categoryName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      color: colorScheme(context).onSurface),
                            ),
                            const Spacer(),
                            GestureDetector(
                                // onTap: () =>
                                //     context.pushNamed(AppRoute.cartPage),
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const CartPage(),
                                      withNavBar: true,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.fade);
                                },
                                child: SvgPicture.asset(AppIcons.cartIcon)),
                            const SizedBox(width: 15),
                            GestureDetector(
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const NotificationPage(),
                                      withNavBar: true,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.fade);
                                },
                                child: SvgPicture.asset(AppIcons.notiIcon)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomTextFormField(
                          hint: 'search_hint'.tr(),
                          borderColor:
                              colorScheme(context).outline.withOpacity(0.4),
                          fillColor: colorScheme(context).surface,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: SvgPicture.asset(AppIcons.filter),
                          ),
                          suffixConstraints:
                              const BoxConstraints(minHeight: 20),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(AppIcons.outlineSearch),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              '${widget.categoryName} ${'product'.tr()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      color: colorScheme(context).onSurface),
                            ),
                            const SizedBox(width: 10),
                            // Text(
                            //   widget.sellerName,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .titleSmall
                            //       ?.copyWith(
                            //           fontSize: 16,
                            //           color: colorScheme(context)
                            //               .outline
                            //               .withOpacity(0.5)),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<ProductController>(
                builder: (context, controller, child) {
                  // Handle loading state
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final products = controller.catagoriesProducts;
                  if (products == null || products.isEmpty) {
                    return const Center(
                      child: Text('No products available.'),
                    );
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 9,
                      crossAxisSpacing: 7,
                      mainAxisExtent: 260,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onLike: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        onTap: () {
                          // PersistentNavBarNavigator.pushNewScreen(
                          //   context,
                          //   screen: ProductDetailPage(product: product),
                          //   withNavBar: true,
                          //   pageTransitionAnimation:
                          //       PageTransitionAnimation.fade,
                          // );
                          context.pushNamed(AppRoute.productDetailPage,
                              extra: product);
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
