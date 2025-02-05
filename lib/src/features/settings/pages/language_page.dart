import 'package:easy_localization/easy_localization.dart'; // For localization
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/common/widget/custom_search_delegate.dart';
import '/src/common/widget/custom_text_field.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<Map<String, String>> languages = [
    {"name": "English", "localeCode": "en"},
    {"name": "Urdu", "localeCode": "ur"},
    {"name": "Spanish", "localeCode": "es"},
    {"name": "Arabic", "localeCode": "ar"},
    {"name": "Dutch", "localeCode": "nl"},
    {"name": "Filipino", "localeCode": "fil"},
    {"name": "Greek", "localeCode": "el"},
    {"name": "Japanese", "localeCode": "ja"},
    {"name": "Russian", "localeCode": "ru"},
    {"name": "Turkish", "localeCode": "tr"},
    {"name": "French", "localeCode": "fr"},
    {"name": "Chinese", "localeCode": "zh"},
    {"name": "Korean", "localeCode": "ko"},
    {"name": "German", "localeCode": "de"},
    {"name": "Portuguese", "localeCode": "pt"},
    {"name": "Bengali", "localeCode": "bn"},
    {"name": "Italian", "localeCode": "it"},
    {"name": "Persian", "localeCode": "fa"},
    {"name": "Swahili", "localeCode": "sw"},
  ];

  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: width * 0.83,
                    child: GestureDetector(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                            searchTerms:
                                languages.map((e) => e['name']!).toList(),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(AppIcons.outlineSearch),
                          ),
                          readOnly: true,
                          hint: 'search_hint'.tr(), // Localized search hint
                          borderColor:
                              colorScheme(context).outline.withOpacity(0.4),
                          fillColor: colorScheme(context).surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        color: colorScheme(context).outline.withOpacity(0.7)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      String language = languages[index]["name"]!;
                      return Column(
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(language,
                                style: textTheme(context).bodyMedium),
                            trailing: selectedLanguage == language
                                ? Icon(Icons.check,
                                    color: colorScheme(context).primary)
                                : null,
                            onTap: () {
                              setState(() {
                                selectedLanguage = language;
                                // Change the locale based on the selected language
                                final localeCode =
                                    languages[index]["localeCode"];
                                context.setLocale(Locale(localeCode!));
                              });
                            },
                          ),
                          if (index != languages.length - 1)
                            Divider(
                              color: AppColor.dividerColor,
                              height: 0,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
