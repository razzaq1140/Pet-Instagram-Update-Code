import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/widget/custom_text_field.dart';
import '/src/features/notification/page/notification_page.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_images.dart';
import '../../common/constants/global_variables.dart';
import '../../models/my_order_model.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample order list
    final orders = [
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.delivered,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.inProcess,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.cancelled,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.inProcess,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.cancelled,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.inProcess,
      ),
      MyOrderModel(
        orderId: '#12548',
        productName: 'Pet House',
        price: 150,
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp',
        status: OrderStatus.cancelled,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Text("MY Order".tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const NotificationPage(), withNavBar: true);
                },
                child: SvgPicture.asset(AppIcons.notiIcon)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomTextFormField(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(AppIcons.outlineSearch),
              ),
              readOnly: true,
              hint: 'Search Order by ID'.tr(), // Localized search hint
              borderColor: colorScheme(context).outline.withOpacity(0.4),
              fillColor: colorScheme(context).surface,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final MyOrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary, // Using theme color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme(context).outline.withOpacity(0.2),
        ),
        // boxShadow:  [
        //   BoxShadow(
        //     color: colorScheme(context).outline.withOpacity(0.07),
        //     blurRadius: 2,
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Order Id',
              style: TextStyle(
                color: AppColor.hintText,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              order.orderId,
              style: const TextStyle(
                color: AppColor.hintText,
                fontSize: 12,
              ),
            ),
          ]),
          const Divider(
            color: AppColor.hintText,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Rounded corners
                child: CachedNetworkImage(
                  imageUrl: order.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      order.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${order.price.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.hintText,
                      ),
                    ),
                  ],
                ),
              ),
              _getStatusButton(order.status, context),
            ],
          )

          // Order Details

          // Status Button
          //
        ],
      ),
    );
  }

  // Widget to display the status button
  Widget _getStatusButton(OrderStatus status, BuildContext context) {
    String statusText;
    Color statusColor;

    switch (status) {
      case OrderStatus.delivered:
        statusText = 'Delivered';
        statusColor = AppColor.appGreen;
        break;
      case OrderStatus.inProcess:
        statusText = 'In Process';
        statusColor = AppColor.appGreen;
        break;
      case OrderStatus.cancelled:
        statusText = 'Cancelled';
        statusColor = AppColor.appOrange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .onPrimary, // Using theme color for text
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
