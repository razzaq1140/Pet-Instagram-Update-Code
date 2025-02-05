import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import '/src/models/product_model.dart';
import '/src/router/routes.dart';
import 'package:provider/provider.dart';
import '../constants/global_variables.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onLike;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onLike,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme(context).onPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme(context).outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme(context).outline.withOpacity(0.2),
                    ),
                    image: DecorationImage(
                      onError: (exception, stackTrace) =>
                          const Icon(Icons.error),
                      image: CachedNetworkImageProvider(
                        widget.product.images.isNotEmpty
                            ? widget.product.images[0]
                            : '',
                        errorListener: (p0) => const Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 0,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // widget.product.isFavorite = !widget.product.isFavorite;
                      });
                      widget.onLike();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: colorScheme(context).primary,
                        ),
                        child: Icon(
                          // Icons.favorite,
                          // color: widget.product.isFavorite
                          //     ? Colors.red // Color when liked
                          //     : Colors.grey, // Color when not liked
                          // size: 20,
                          Icons.favorite,
                          color: Theme.of(context)
                              .colorScheme
                              .error // Color when liked
                          // : colorScheme(context)
                          //     .onPrimary, // Color when not liked
                          ,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text(
                  "\$${widget.product.price}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme(context).primary,
                  child: Consumer<ProductController>(
                    builder: (context, value, child) => IconButton(
                      icon: Icon(
                        Icons.add_box_outlined,
                        color: colorScheme(context).surface,
                        size: 18,
                      ),
                      onPressed: () async {
                        await value.addToCart(
                            productId: widget.product.id, quantity: 1);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Consumer<ProductController>(
                builder: (context, controller, child) => GestureDetector(
                  onTap: () {
                    controller.buyNow(
                      productId: widget.product.id,
                      quantity: 1,
                      address: '123 Street, City',
                      promoCode: '1234',
                    );
                    if (mounted) {
                      context.pushNamed(
                        AppRoute.orderconfirmation,
                        extra: true,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        color: colorScheme(context).primary),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                    child: Text(
                      "Buy Now".tr(),
                      style: textTheme(context)
                          .labelLarge
                          ?.copyWith(color: colorScheme(context).onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
