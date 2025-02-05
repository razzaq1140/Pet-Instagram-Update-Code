import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../common/constants/app_colors.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('faqs'.tr()), // Localized title
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary, // Set onPrimary color for the container
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.hintText),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'faq_1_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_1_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_2_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_2_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_3_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_3_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_4_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_4_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_5_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_5_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_6_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_6_answer'.tr(), // Localized answer
              ),
              const SizedBox(height: 16),
              Text(
                'faq_7_question'.tr(), // Localized question
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'faq_7_answer'.tr(), // Localized answer
              ),
              // Add more FAQ items as necessary
            ],
          ),
        ),
      ),
    );
  }
}
