import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/notification/page/notification_page.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_images.dart';
import '../../models/customer_product_model.dart';

class AllCustomersPage extends StatelessWidget {
  const AllCustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Map of dates and customer data
    Map<String, List<CustomerProductModel>> productData = {
      "09-Oct-2024": [
        CustomerProductModel(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          name: "Robert Fox",
          email: 'debbie.baker@example.com',
          orderDetail: "Order Detail",
        ),
        CustomerProductModel(
          imageUrl:
              'https://royalcaninpetfood.pk/wp-content/uploads/2023/10/royal-canin-maxi-starter-2.jpg',
          name: "Arlene McCoy",
          email: 'kenzi.lawson@example.com',
          orderDetail: "Order Detail",
        ),
        CustomerProductModel(
          imageUrl:
              'https://img.freepik.com/free-photo/colorful-pet-accessories-still-life-concept_23-2148949591.jpg?t=st=1727687914~exp=1727691514~hmac=e7544c4cbedf90668a014bb94ff9da3c14042254e4ff33b001a5ccdae97ea31d&w=360',
          name: "Leslie Alexander",
          email: 'georgia.young@example.com',
          orderDetail: "Order Detail",
        ),
      ],
      "10-Oct-2024": [
        CustomerProductModel(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          name: "Kathryn Murphy",
          email: 'nevaeh.simmons@example.com',
          orderDetail: "Order Detail",
        ),
        CustomerProductModel(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          name: "Kathryn Murphy",
          email: 'nevaeh.simmons@example.com',
          orderDetail: "Order Detail",
        ),
        CustomerProductModel(
          imageUrl:
              'https://thebowpoint.pk/cdn/shop/files/551E4E54-BA00-4473-844D-E0D8BD52DC21.jpg?v=1708297217&width=713',
          name: "Kathryn Murphy",
          email: 'nevaeh.simmons@example.com',
          orderDetail: "Order Detail",
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: Text(
          "Customer",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 22),
          textAlign: TextAlign.left,
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const NotificationPage(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            },
            child: SvgPicture.asset(AppIcons.notiIcon),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: productData.entries.map((entry) {
          String date = entry.key;
          List<CustomerProductModel> products = entry.value;

          return ProductListWidget(products: products, date: date);
        }).toList(),
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final List<CustomerProductModel> products;
  final String date;

  const ProductListWidget(
      {super.key, required this.products, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Divider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            date,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
                ),
          ),
        ),
        Divider(
          thickness: 2.0,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),

        // List of products for this date
        ...products.map((product) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 2.0,
                ),
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product image
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      placeholder: (context, url) => const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          product.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showOrderDetailDialog(context, product, products);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: colorScheme(context).primary,
                      ),
                      child: Text(
                        "Order Detail",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            // fontSize: 20,
                            color: colorScheme(context).onSecondary),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showOrderDetailDialog(BuildContext context,
      CustomerProductModel customer, List<CustomerProductModel> allProducts) {
    // Select a random product from the list
    final randomProduct = allProducts[Random().nextInt(allProducts.length)];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme(context).onSecondary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Order Id ", // Normal text
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color, // Default color from theme
                          ),
                    ),
                    TextSpan(
                      text: "#12548", // The Order ID with grey color
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.7), // Grey color from theme
                          ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColor.appRed,
                child: IconButton(
                  icon: Icon(Icons.close,
                      size: 17, color: colorScheme(context).onSecondary),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: randomProduct.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(randomProduct.name),
                subtitle: const Text("Pet Household"),
                trailing: const Text("\$150"),
              ),
              const Divider(),
              ListTile(
                leading: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: customer.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(customer.name),
                subtitle: Text(customer.email),
              ),
              const SizedBox(height: 10),
              const Text(
                "Shipping Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text("California Street #3 Apt #4 #4451"),
            ],
          ),
        );
      },
    );
  }
}
