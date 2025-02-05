import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_images.dart';
import '../../models/sales_model_product.dart';


class AllSalesPage extends StatelessWidget {
  const AllSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of SalesProduct data
    List<Widget> sales = [
      const SalesDateWidget(date: "09-Oct-2024"),  // Add Date Widget
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
      const SalesDateWidget(date: "10-Oct-2024"),  // Add another date after a few products
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
      const SalesDateWidget(date: "11-Oct-2024"),  // Add another date as required
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sales",
                  style: const TextTheme().bodyMedium,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(AppIcons.notiIcon),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(7.0),
        children: sales,  // Use the sales list which includes date widgets and product cards
      ),
    );
  }
}

class SalesProductCard extends StatelessWidget {
  final SalesProduct product;

  const SalesProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 2.0, // Border similar to your provided image
        ),
        color: Theme.of(context)
            .colorScheme
            .onSecondary, // Background color similar to the image
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Product Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppColor.hintText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sale Items",
                        style: TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                      Text(
                        product.saleItems.toString(),
                        style: const TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppColor.hintText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Category",
                        style: TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                      Text(
                        product.productCategory,
                        style: const TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppColor.hintText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Sale",
                        style: TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                      Text(
                        '\$${product.totalSale}',
                        style: const TextStyle(
                          color: AppColor.hintText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesDateWidget extends StatelessWidget {
  final String date;

  const SalesDateWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        date,
        style: TextStyle(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
