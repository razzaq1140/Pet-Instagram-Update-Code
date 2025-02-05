import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_button.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/features/seller_dashbord/pages/product/all_products_page.dart';

import '../../../../common/constants/app_images.dart';
import '../widget/inputdata_of_sales.dart';

class ProductStatementPage extends StatefulWidget {
  const ProductStatementPage({super.key});

  @override
  State<ProductStatementPage> createState() => _ProductStatementPageState();
}

class _ProductStatementPageState extends State<ProductStatementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        // backgroundColor: Colors.transparent,
        title: Text(
          "Products Statement",
          style: const TextTheme().bodyMedium,
          textAlign: TextAlign.left,
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
                onTap: () {
                  // context.pushNamed(AppRoute.notificationPage);
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const NotificationPage(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true);
                },
                child: SvgPicture.asset(AppIcons.notiIcon)),
          )
        ],
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme(context).onSecondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme(context).outline.withOpacity(0.3),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InputDataOfSales(
                        label: "From"), // Independent Date Picker for "From"
                    SizedBox(height: 20),
                    InputDataOfSales(
                        label: "To"), // Independent Date Picker for "To"
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              onTap: () {
                // context
                //     .pushNamed(AppRoute.allProducts); // Navigate to report page
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const AllProductsPage(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              text: 'View Report',
            ),
          ],
        ),
      ),
    );
  }
}
