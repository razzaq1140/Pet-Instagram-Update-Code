import 'package:easy_localization/easy_localization.dart'; // Import for localization
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text("about_title".tr()), // Localized title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme(context).onPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: colorScheme(context).outline.withOpacity(0.3)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "about_section_1".tr(), // Localized text
                    style: textTheme(context).bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "about_section_2".tr(), // Localized text
                    style: textTheme(context).bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "about_section_3".tr(), // Localized text
                    style: textTheme(context).bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
