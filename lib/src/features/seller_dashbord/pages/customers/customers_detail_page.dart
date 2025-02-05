import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_button.dart';
import '/src/features/history/all_customers_page.dart';
import '/src/features/notification/page/notification_page.dart';
import '../../../../common/constants/app_images.dart';

class CustomersDetailPage extends StatelessWidget {
  const CustomersDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "Customer Detail",
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
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
                onTap: () {
                  // context.pushNamed(AppRoute.notificationPage);
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const NotificationPage(),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade);
                },
                child: SvgPicture.asset(AppIcons.notiIcon)),
          )
        ],
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
                    InputDateWidget(label: "From"),
                    SizedBox(height: 20),
                    InputDateWidget(label: "To"),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
                onTap: () {
                  // context.pushNamed(AppRoute.allCustomers);
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const AllCustomersPage(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      withNavBar: true);
                },
                text: 'View Report')
          ],
        ),
      ),
    );
  }
}

class InputDateWidget extends StatelessWidget {
  final String label;
  const InputDateWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme(context).surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Text(
                  "09-Oct-2024",
                  style: const TextTheme().titleMedium?.copyWith(
                      color: colorScheme(context).outline.withOpacity(0.7)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Calendar Icon Container
            Container(
              decoration: BoxDecoration(
                color: colorScheme(context).surface,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.calendar_today,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
