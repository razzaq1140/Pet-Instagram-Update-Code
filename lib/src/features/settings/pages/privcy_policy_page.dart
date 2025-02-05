import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../common/constants/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('privacy_policy'.tr(), textAlign: TextAlign.left), // Localized title
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
                'introduction'.tr(), // Localized heading
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'introduction_text'.tr(), // Localized paragraph
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'information_we_collect'.tr(), // Localized heading
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'information_we_collect_text'.tr(), // Localized paragraph
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'how_we_use_your_information'.tr(), // Localized heading
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'how_we_use_your_information_text'.tr(), // Localized paragraph
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'information_sharing_and_disclosure'.tr(), // Localized heading
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'information_sharing_and_disclosure_text'.tr(), // Localized paragraph
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'your_rights'.tr(), // Localized heading
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'your_rights_text'.tr(), // Localized paragraph
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
