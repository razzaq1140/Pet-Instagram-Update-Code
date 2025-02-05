import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import '/src/features/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/profile/pages/my_profile_page.dart';
import '../common/constants/app_images.dart';
import 'buyer_and_seller/buyer/pages/shopping_page.dart';
import 'buyer_and_seller/seller/pages/seller_center_page.dart';
import 'chat/chat_page.dart';
import 'feed_and_recipe/pages/feed_and_recipe_page.dart';
import 'home/pages/home_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late PersistentTabController _controller;
  int _currentIndex = 0;

  final List<Widget> _buyerPages = [
    const HomePage(),
    const FeedPage(),
    const ChatPage(),
    const PetShoppingPage(),
    const MyProfilePage(),
  ];

  final List<Widget> _sellerPages = [
    const HomePage(),
    const FeedPage(),
    const ChatPage(),
    const SellerCenterPage(),
    const MyProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<PersistentBottomNavBarItem> _buildNavBarItems(bool isSeller) {
    return [
      _createNavBarItem(AppIcons.homeIcon, "", 0),
      _createNavBarItem(AppIcons.petFoodIcon, "", 1),
      _createNavBarItem(AppIcons.bunnyIcon, "", 2),
      _createNavBarItem(
        isSeller ? AppIcons.petShopIcon : AppIcons.petShopIcon,
        isSeller ? "" : "",
        3,
      ),
      _createNavBarItem(AppIcons.profileIcon, "", 4),
    ];
  }

  PersistentBottomNavBarItem _createNavBarItem(
      String iconPath, String title, int index) {
    return PersistentBottomNavBarItem(
      icon: CircleAvatar(
        backgroundColor: _currentIndex == index
            ? colorScheme(context).primary
            : Colors.transparent,
        child: Image.asset(iconPath, height: 35),
      ),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    );
  }

  List<Widget> _buildScreens(bool isSeller) {
    return isSeller ? _sellerPages : _buyerPages;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // You can return a Future here to handle the pop behavior.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Consumer<SettingsController>(
        builder: (context, settingsController, child) {
          bool isSeller = settingsController.isSeller;

          log("isSeller: $isSeller, currentRole: ${settingsController.currentRole}");
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(isSeller),
            items: _buildNavBarItems(isSeller),
            confineToSafeArea: true,
            backgroundColor: Colors.white,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: false,
            navBarHeight: kBottomNavigationBarHeight,
            navBarStyle: NavBarStyle.simple,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
