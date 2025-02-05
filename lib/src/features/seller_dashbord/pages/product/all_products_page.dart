import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/features/notification/page/notification_page.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../models/sales_model_product.dart';
import '../sales/all_sales_page.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of SalesProduct data
    List<Widget> sales = [
      const SalesDateWidget(date: "09-Oct-2024"), // Add Date Widget
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          productName: "Pet House",
          saleItems: 35,
          productCategory: "Pet",
          totalSale: 1400,
        ),
      ),
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              "https://img.freepik.com/free-photo/still-life-pet-food-composition_23-2148982347.jpg?w=360&t=st=1727687479~exp=1727688079~hmac=fc99e9bf7be28a8eacf8b98d542a5f48223aac30dc43496c382e2feb7a4b81cd",
          productName: "Dog Collar",
          saleItems: 50,
          productCategory: "Pet Accessories",
          totalSale: 1800,
        ),
      ),
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          productName: "Pet House",
          saleItems: 35,
          productCategory: "Pet",
          totalSale: 1400,
        ),
      ),
      const SalesDateWidget(
          date: "10-Oct-2024"), // Add another date after a few products
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              "https://img.freepik.com/free-photo/still-life-pet-food-composition_23-2148982347.jpg?w=360&t=st=1727687479~exp=1727688079~hmac=fc99e9bf7be28a8eacf8b98d542a5f48223aac30dc43496c382e2feb7a4b81cd",
          productName: "Dog Collar",
          saleItems: 50,
          productCategory: "Pet Accessories",
          totalSale: 1800,
        ),
      ),
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          productName: "Pet House",
          saleItems: 35,
          productCategory: "Pet",
          totalSale: 1400,
        ),
      ),
      const SalesDateWidget(
          date: "11-Oct-2024"), // Add another date as required
      SalesProductCard(
        product: SalesProduct(
          imageUrl:
              "https://img.freepik.com/free-photo/still-life-pet-food-composition_23-2148982347.jpg?w=360&t=st=1727687479~exp=1727688079~hmac=fc99e9bf7be28a8eacf8b98d542a5f48223aac30dc43496c382e2feb7a4b81cd",
          productName: "Dog Collar",
          saleItems: 50,
          productCategory: "Pet Accessories",
          totalSale: 1800,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Product",
                  style: const TextTheme().bodyMedium,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const NotificationPage(),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                  withNavBar: true);
            },
            child: SvgPicture.asset(AppIcons.notiIcon),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(7.0),
        children:
            sales, // Use the sales list which includes date widgets and product cards
      ),
    );
  }
}
