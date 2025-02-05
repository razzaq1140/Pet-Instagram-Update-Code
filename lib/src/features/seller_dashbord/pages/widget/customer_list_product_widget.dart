import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../models/customer_product_model.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
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
                  Column(
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  )
                  // Product name

                  // Product price
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
