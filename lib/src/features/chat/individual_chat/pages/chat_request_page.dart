import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/global_variables.dart';
import '../../../../common/widget/custom_text_field.dart';
import '../../../../models/pet__friends_model.dart';

class ChatRequestPage extends StatefulWidget {
  const ChatRequestPage({super.key});

  @override
  ChatRequestPageState createState() => ChatRequestPageState();
}

class ChatRequestPageState extends State<ChatRequestPage> {
  TextEditingController searchController = TextEditingController();

  // List of Pet Followers (data handled through model class)
  final List<PetFriends> followers = [
    PetFriends(
      name: 'Kathryn Murphy',
      subtitle: 'Darrell Steward',
      avatarUrl:
          'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
    ),
    PetFriends(
        name: 'Annette Black',
        subtitle: 'Esther Howard',
        avatarUrl:
            "https://as2.ftcdn.net/v2/jpg/01/99/00/79/1000_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg"),
    PetFriends(
        name: 'Eleanor Pena',
        subtitle: 'Cody Fisher',
        avatarUrl:
            "https://as2.ftcdn.net/v2/jpg/01/99/00/79/1000_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg"),
    PetFriends(
        name: 'Jerome Bell',
        subtitle: 'Wade Warren',
        avatarUrl:
            "https://as2.ftcdn.net/v2/jpg/01/99/00/79/1000_F_199007925_NolyRdRrdYqUAGdVZV38P4WX8pYfBaRP.jpg"),
  ];

  void _showActionBottomSheet(BuildContext context, String name) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Minimize the height of the bottom sheet
            children: [
              Text(
                'Chat Request from $name',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you want to accept, reject, or block this chat request?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add your accept logic here
                    },
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 15,
                      ),
                      side: const BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add your reject logic here
                    },
                    icon: const Icon(Icons.cancel, color: Colors.orange),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 15,
                      ),
                      side: const BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add your block logic here
                    },
                    icon: const Icon(Icons.block, color: Colors.red),
                    label: const Text('Block'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 15,
                      ),
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat Requests',
          textAlign: TextAlign.left,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomTextFormField(
              controller: searchController,
              hint: 'search_hint'.tr(),
              prefixIcon: Icon(
                Icons.search,
                color: AppColor.appIcon,
              ),
              borderColor: colorScheme(context).outline.withOpacity(0.4),
              fillColor: colorScheme(context).surface,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SvgPicture.asset(AppIcons.filter),
              ),
              suffixConstraints: const BoxConstraints(minHeight: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final follower = followers[index];
                return ListTile(
                  onTap: () {
                    _showActionBottomSheet(context, follower.name);
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: follower.avatarUrl.contains('http')
                        ? CachedNetworkImageProvider(follower.avatarUrl)
                        : FileImage(File(follower.avatarUrl)) as ImageProvider,
                  ),
                  title: Text(follower.name),
                  subtitle: Text(follower.subtitle),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
