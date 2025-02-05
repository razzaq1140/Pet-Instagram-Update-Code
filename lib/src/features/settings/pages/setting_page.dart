// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/app_images.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';
import '/src/features/notification/page/notification_page.dart';
import '/src/features/order_history/pages/order_history_page.dart';
import '/src/features/settings/my_order_page.dart';
import '/src/features/settings/pages/about_page.dart';
import '/src/features/settings/pages/account_page.dart';
import '/src/features/settings/pages/faqs_page.dart';
import '/src/features/settings/pages/favourite_page.dart';
import '/src/features/settings/pages/language_page.dart';
import '/src/features/settings/pages/order_tracking_page.dart';
import '/src/features/settings/pages/privcy_policy_page.dart';
import '/src/features/settings/pages/terms_and_conditions_page.dart';

import '../../../common/utils/shared_preferences_helper.dart';
import '../../../common/widget/custom_search_delegate.dart';
import '../../../common/widget/custom_settings_tile.dart';
import '../../../common/widget/custom_text_field.dart';
import '../../../router/routes.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Text("profile".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                        searchTerms: [
                          'account'.tr(),
                          'order_tracking'.tr(),
                          'notifications'.tr(),
                          'favourite_products'.tr(),
                          'language'.tr(),
                          'privacy_policy'.tr(),
                          'terms_conditions'.tr(),
                          'faqs'.tr(),
                          'about'.tr(),
                        ],
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
                      hint: 'search_hint'.tr(),
                      borderColor:
                          colorScheme(context).outline.withOpacity(0.4),
                      fillColor: colorScheme(context).surface,
                    ),
                  ),
                ),
                CustomSettingsTile(
                  icon: SvgPicture.asset(AppIcons.personIcon),
                  title: "account".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.accountPage);
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const AccountPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: Image.asset(AppIcons.trackingIcon),
                  title: "order_tracking".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.orderTrackingPage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const OrderTrackingPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: SvgPicture.asset(AppIcons.notiIcon),
                  title: "notifications".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.notificationPage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const NotificationPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: const Icon(
                    Icons.favorite_border_outlined,
                    color: AppColor.hintText,
                  ),
                  title: "favourite_products".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.favoritePage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const FavouritePage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: const Icon(
                    Icons.other_houses,
                    color: AppColor.hintText,
                  ),
                  title: "my_order".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.myOrder);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const MyOrderPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                Consumer<SettingsController>(
                  builder: (context, value, child) => CustomSettingsTile(
                    icon: const Icon(
                      Icons.switch_account_outlined,
                      color: AppColor.hintText,
                    ),
                    title: value.isSeller
                        ? "switch_to_buyer_account".tr()
                        : "switch_to_seller_account".tr(),
                    onTap: () async {
                      await value.switchProfile(context);

                      final nextPage = value.isSeller
                          ? AppRoute.navigationBar
                          : AppRoute.navigationBar;
                      context.goNamed(nextPage);
                      setState(() {});
                    },
                  ),
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: SvgPicture.asset(AppIcons.languageIcon),
                  title: "language".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.languagePage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const LanguagePage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: SvgPicture.asset(AppIcons.policyIcon),
                  title: "privacy_policy".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.privcyPolicy);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const PrivacyPolicyPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: Image.asset(
                    AppImages.iconDcoument,
                    height: 23,
                  ),
                  title: "terms_conditions".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.termsAndCondition);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const TermsAndConditionsPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: Image.asset(AppIcons.faqIcon),
                  title: "faqs".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.faqsPage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const FaqsPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: SvgPicture.asset(AppIcons.aboutIcon),
                  title: "about".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.aboutPage);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const AboutPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                CustomSettingsTile(
                  icon: const Icon(
                    Icons.list_alt_rounded,
                    color: AppColor.hintText,
                  ),
                  title: "order_history".tr(),
                  onTap: () {
                    // context.pushNamed(AppRoute.orderHistory);

                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const OrderHistoryPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        withNavBar: true);
                  },
                ),
                Divider(color: AppColor.dividerColor, height: 0),
                Consumer<SettingsController>(
                  builder: (context, controller, child) => ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(
                      'Private'.tr(),
                      style: textTheme(context).titleMedium,
                    ),
                    trailing: Switch(
                      activeColor: Colors.green,
                      value: controller.currentPrivacyStatus ?? false,
                      onChanged: (value) async {
                        await controller.togglePrivacy();
                        controller.currentPrivacyStatus = value;

                        log('Switch is now: ${controller.currentPrivacyStatus}');
                      },
                    ),
                  ),
                ),
                Divider(color: AppColor.dividerColor, height: 0),
              ],
            ),
            const SizedBox(
              height: 90,
            ),
            ListTile(
              onTap: () {
                SharedPrefHelper.saveBool(isBuyerText, true);
                MyAppRouter.clearAndNavigate(context, AppRoute.welcomeScreen);
              },
              contentPadding: const EdgeInsets.all(0),
              leading: SvgPicture.asset(AppIcons.logoutIcon),
              title: Text(
                "logout".tr(),
                style: textTheme(context).titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
