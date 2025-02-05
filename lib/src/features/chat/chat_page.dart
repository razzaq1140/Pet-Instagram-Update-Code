import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/src/features/chat/individual_chat/pages/chat_page.dart';
import '../../common/constants/global_variables.dart';
import 'group_chat/pages/group_chat_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  PetFollowerScreenState createState() => PetFollowerScreenState();
}

class PetFollowerScreenState extends State<ChatPage> {
  TextEditingController searchController = TextEditingController();
  bool isChatSelected = true; // Default selection is "Chat"
  final PageController _pageController =
      PageController(initialPage: 0); // PageView controller

  // List of Pet Followers (data handled through model class)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    isChatSelected = index == 0;
                  });
                },
                children: const [
                  IndividualChatPage(),
                  GroupChatPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: colorScheme(context).onPrimary,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: colorScheme(context).outline.withOpacity(0.06))),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isChatSelected = true;
                          });
                          _pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isChatSelected
                                ? colorScheme(context).primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'chat'.tr(),
                            style: TextStyle(
                              color: isChatSelected
                                  ? colorScheme(context).surface
                                  : colorScheme(context)
                                      .outline
                                      .withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isChatSelected = false;
                          });
                          _pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: !isChatSelected
                                ? colorScheme(context).primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'group'.tr(),
                            style: TextStyle(
                              color: !isChatSelected
                                  ? colorScheme(context).surface
                                  : colorScheme(context)
                                      .outline
                                      .withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
