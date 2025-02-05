import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '/src/router/routes.dart';

import '../../../common/constants/app_images.dart';
import '../../../common/constants/global_variables.dart';
import '../../../common/widget/custom_text_field.dart';
import '../model/order_history_model.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {
  late PageController _pageController;
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  List<OrderHistoryModel> orders = [
    OrderHistoryModel(
      imageUrl:
          'https://www.akc.org/wp-content/uploads/2021/10/Two-Golden-Retriever-puppies-eating-kibble-from-the-same-bowl.jpg',
      name: "Robert Fox",
      email: 'debbie.baker@example.com',
      orderDetail: "Pet House",
    ),
    OrderHistoryModel(
      imageUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
      name: "Arlene McCoy",
      email: 'kenzi.lawson@example.com',
      orderDetail: "Pet House",
    ),
    OrderHistoryModel(
      imageUrl:
          "https://4368135.fs1.hubspotusercontent-na1.net/hubfs/4368135/Google%20Drive%20Integration/How%20cats%20are%20fed%20in%20a%20multi-cat%20household-1.png",
      name: "Leslie Alexander",
      email: 'georgia.young@example.com',
      orderDetail: "Pet House",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text('order_history'.tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoute.notificationPage);
                },
                child: SvgPicture.asset(AppIcons.notiIcon)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(AppIcons.outlineSearch),
              ),
              readOnly: true,
              hint: 'search_order_by_id'.tr(),
              borderColor: colorScheme(context).outline.withOpacity(0.4),
              fillColor: colorScheme(context).surface,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: colorScheme(context).onSecondary,
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab(context, 'orders'.tr(), 0),
                    _buildTab(context, 'in_process'.tr(), 1),
                    _buildTab(context, 'delivered'.tr(), 2),
                    _buildTab(context, 'canceled'.tr(), 3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildOrderList('Orders'),
                  _buildOrderList('In Process'),
                  _buildOrderList('Delivered'),
                  _buildOrderList('Canceled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    bool isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme(context).primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme(context).onPrimary
                    : colorScheme(context).onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    List<OrderHistoryModel> filteredOrders =
        orders.where((order) => order.status == status).toList();

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          customer: filteredOrders[index],
          onChangeStatus: (newStatus) {
            setState(() {
              // Update both the filtered orders and the main orders list
              filteredOrders[index].status = newStatus;
              orders[orders.indexOf(filteredOrders[index])].status = newStatus;
            });
          },
        );
      },
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderHistoryModel customer;
  final Function(String) onChangeStatus;

  const OrderCard({
    super.key,
    required this.customer,
    required this.onChangeStatus,
  });

  @override
  OrderCardState createState() => OrderCardState();
}

class OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Order Id ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: "#12548", // You can replace this with dynamic data
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              // PopupMenuButton styled as a button
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    // Directly update the order status from the popup
                    widget.onChangeStatus(value);
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'In Process',
                    child: Text('in_process'.tr()),
                  ),
                  PopupMenuItem(
                    value: 'Delivered',
                    child: Text('delivered'.tr()),
                  ),
                  PopupMenuItem(
                    value: 'Canceled',
                    child: Text('canceled'.tr()),
                  ),
                ],
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  label: Text(
                    widget.customer.status, // Show the actual order status
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.4),
                    ),
                  ),
                  onPressed: null,
                ),
              ),
            ],
          ),

          // Order details
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.customer.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget
                .customer.orderDetail), // Dynamically display order details
            subtitle: const Text('Pet Household'),
            trailing: const Text("\$150"), // You can replace with dynamic price
          ),
          Divider(
            color: colorScheme(context).outline.withOpacity(0.2),
          ),
          ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.customer.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.customer.name), // Customer name
            subtitle: Text(widget.customer.email), // Customer email
          ),
          const Text(
            "Shipping Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
              "California Street #3 Apt #4 #4451"), // Address (can be dynamic)
        ],
      ),
    );
  }
}
