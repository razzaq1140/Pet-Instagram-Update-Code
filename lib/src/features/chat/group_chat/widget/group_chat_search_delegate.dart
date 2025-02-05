// ignore: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/src/common/constants/global_variables.dart';
import '/src/features/chat/group_chat/widget/group_chat_widget.dart';
import '../model/joined_chat_group_model.dart';

class GroupChatSearchDelegate extends SearchDelegate<JoinedChatGroupModel> {
  final List<JoinedChatGroupModel> groupList;

  GroupChatSearchDelegate({required this.groupList});

  @override
  String? get searchFieldLabel => 'search'.tr();

  @override
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        titleSmall: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        color: Colors.black,
        fontSize: 16,
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<JoinedChatGroupModel> searchResults = groupList.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (searchResults.isEmpty) {
      return Center(child: Text('no_matching_groups_found'.tr()));
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final group = searchResults[index];

        return ListTile(
          title: Text(
            group.name,
            style: textTheme(context)
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          subtitle: Text(
            'Group Chat',
            style: textTheme(context)
                .labelSmall!
                .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
          ),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<JoinedChatGroupModel> suggestions = groupList.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GroupChatWidget(
            group: suggestions[index],
          ),
        );
      },
    );
  }
}
