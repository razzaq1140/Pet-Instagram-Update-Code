import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/widget/custom_search_delegate.dart';
import '/src/features/cart/pages/cart_page.dart';
import '/src/features/notification/page/notification_page.dart';

import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_text_field.dart';

class SellerModel {
  final String imageUrl;
  final String name;
  final String productCount;
  final String bestSelling;

  SellerModel({
    required this.imageUrl,
    required this.name,
    required this.productCount,
    required this.bestSelling,
  });
}

class TopSellersPage extends StatelessWidget {
  final List<SellerModel> topSellers = [
    SellerModel(
      bestSelling: '450 best_selling'.tr(),
      productCount: '1.5k Products',
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: 'Brok Simmons',
    ),
    SellerModel(
      bestSelling: '450 best_selling'.tr(),
      productCount: '1.5k Products',
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: 'Carn William',
    ),
    SellerModel(
      bestSelling: '450 best_selling'.tr(),
      productCount: '1.5k Products',
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: 'Lie Alexandra',
    ),
    SellerModel(
      bestSelling: '450 best_selling'.tr(),
      productCount: '1.5k Products',
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: 'Brok Simmons',
    ),
    SellerModel(
      bestSelling: '450 best_selling'.tr(),
      productCount: '1.5k Products',
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: 'Lie Alexandra',
    ),
  ];

  TopSellersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
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
                                'sellers'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: 20,
                                        color: colorScheme(context).onSurface),
                              ),
                              const Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const CartPage(),
                                        withNavBar: true,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade);
                                  },
                                  // onTap: () =>
                                  //     context.pushNamed(AppRoute.cartPage),
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
                                  // onTap: () => context
                                  //     .pushNamed(AppRoute.notificationPage),
                                  child: SvgPicture.asset(AppIcons.notiIcon)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () {
                              // Trigger the search delegate when the field is tapped
                              showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(
                                  searchTerms: [
                                    'Dogs',
                                    'Cats',
                                    'Birds',
                                    'Fish',
                                    'Pets'
                                  ],
                                ),
                              );
                            },
                            child: AbsorbPointer(
                              // AbsorbPointer will ensure the text field doesn't take direct input
                              child: CustomTextFormField(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child:
                                      SvgPicture.asset(AppIcons.outlineSearch),
                                ),

                                readOnly:
                                    true, // Make sure the field is read-only
                                hint: 'search_hint'.tr(),
                                borderColor: colorScheme(context)
                                    .outline
                                    .withOpacity(0.4),
                                fillColor: colorScheme(context).surface,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(AppIcons.filter),
                                ),
                                suffixConstraints:
                                    const BoxConstraints(minHeight: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'top_sellers'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16, color: colorScheme(context).onSurface),
                ),
                const SizedBox(height: 15),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 9,
                      mainAxisExtent: 250,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: topSellers.length,
                    itemBuilder: (context, index) {
                      final seller = topSellers[index];
                      return SizedBox(
                        //height: 260, // Set a fixed height for each grid item
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme(context).onPrimary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.hintText),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  seller.imageUrl,
                                ),
                                radius: 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                seller.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                seller.productCount,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: colorScheme(context)
                                            .outline
                                            .withOpacity(0.3)),
                              ),
                              Text(
                                seller.bestSelling,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: colorScheme(context)
                                            .outline
                                            .withOpacity(0.3)),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme(context).onSurface,
                                  ),
                                ),
                                child:
                                    Center(child: Text('view_products'.tr())),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
