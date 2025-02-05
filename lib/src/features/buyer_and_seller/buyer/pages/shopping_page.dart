import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/widget/custom_search_delegate.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import '/src/features/cart/pages/cart_page.dart';
import '/src/features/categories/pages/pet_categories_page.dart';
import '/src/features/categories/pages/top_sellers.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/features/product_details/product_detail_page.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/product_card.dart';
import '../../../../models/product_model.dart';

class PetShoppingPage extends StatefulWidget {
  const PetShoppingPage({super.key});

  @override
  PetShoppingPageState createState() => PetShoppingPageState();
}

class PetShoppingPageState extends State<PetShoppingPage> {
  bool isLiked = false;
  late ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Provider.of(context, listen: false);

    Timer(
      const Duration(milliseconds: 20),
      () {
        productController.catagories();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<SellerModels> topSellers = [
      SellerModels(
        imageUrl:
            'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        name: 'Brok Simmons',
      ),
      SellerModels(
        imageUrl:
            'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        name: 'Carn William',
      ),
      SellerModels(
        imageUrl:
            'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        name: 'Lie Alexandra',
      ),
    ];

    final List<ProductModel> featuredProducts = [];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'shopping'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 20,
                              color: colorScheme(context).onSurface,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const CartPage(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.fade);
                    },
                    // onTap: () => context.pushNamed(AppRoute.cartPage),
                    child: SvgPicture.asset(AppIcons.cartIcon),
                  ),
                  // const SizedBox(width: 15),
                  // GestureDetector(
                  //     onTap: () {
                  //       context.pushNamed(AppRoute.setting);
                  //     },
                  //     child: SvgPicture.asset(
                  //       AppIcons.personIcon,
                  //       width: 19,
                  //       height: 19,
                  //     )),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const NotificationPage(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.fade);
                    },
                    // onTap: () => context.pushNamed(AppRoute.notificationPage),
                    child: SvgPicture.asset(AppIcons.notiIcon),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(
                      searchTerms: [
                        'dogs'.tr(),
                        'cats'.tr(),
                        'birds'.tr(),
                        'fish'.tr(),
                      ],
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(AppIcons.outlineSearch),
                    ),
                    readOnly: true,
                    hint: 'search_hint'.tr(),
                    borderColor: colorScheme(context).outline.withOpacity(0.4),
                    fillColor: colorScheme(context).surface,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(AppIcons.filter),
                    ),
                    suffixConstraints: const BoxConstraints(minHeight: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(AppImages.petOffImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'categories'.tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 20, color: colorScheme(context).onSurface),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: Consumer<ProductController>(
                    builder: (context, value, child) {
                  final categories = productController.categories;
                  if (categories == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: PetCategoriesPage(
                                categoryName: category['name'],
                                categoryId: category['id'],
                                searchController: TextEditingController(),
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.hintText,
                                  ),
                                  child: Image.network(
                                    category["image_url"] ??
                                        'https://pet-insta.nextwys.com/https://pet-insta.nextwys.com/uploads/product_images/post_f0cOP65GpW.jpg',
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          size: 60, color: Colors.grey);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category['name'] ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontSize: 12,
                                        color: colorScheme(context).onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'top_sellers'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 20, color: colorScheme(context).onSurface),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Combine GoRouter push with PersistentNavBarNavigator to navigate with parameters
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: TopSellersPage(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    // onTap: () {
                    //   context.pushNamed(AppRoute.topSeller);
                    // },
                    child: Text(
                      'see_all'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme(context).onSurface.withOpacity(0.5),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topSellers.length,
                  itemBuilder: (context, index) {
                    final seller = topSellers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          // Use PersistentNavBarNavigator to navigate to PetCategoriesPage with parameters
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: PetCategoriesPage(
                              categoryId: 1,
                              categoryName: 'Housing',
                              searchController: TextEditingController(),
                            ),
                            withNavBar:
                                true, // Ensure the bottom nav bar remains visible
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },

                        // onTap: () {
                        //   // Filter the products for this seller or category
                        //   final filteredProducts = featuredProducts
                        //       .where((product) => product.category == 'Housing')
                        //       .toList();

                        //   // Pass seller's name along with the category and products
                        //   context.pushNamed(
                        //     AppRoute.categoriesPage,
                        //     extra: {
                        //       'category': 'Housing', // Pass the category
                        //       'products':
                        //           filteredProducts, // Pass filtered products
                        //       'searchController':
                        //           TextEditingController(), // Pass search controller
                        //       'sellerName': seller.name, // Pass seller's name
                        //     },
                        //   );
                        // },
                        child: Container(
                          width: 170,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  seller.imageUrl,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  seller.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "featured_products".tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 20, color: colorScheme(context).onSurface),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add logic for See All
                    },
                    child: Text(
                      'See All',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme(context).onSurface.withOpacity(0.5),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 7,
                  mainAxisExtent: 240,
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
                  return ProductCard(
                    product: product,
                    onLike: () {},
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: ProductDetailPage(
                            product: product,
                          ),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.fade);
                      context.pushNamed(AppRoute.productDetailPage,
                          extra: product);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
