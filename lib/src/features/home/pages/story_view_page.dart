import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/router/routes.dart';
import 'package:story_view/story_view.dart';
import '../model/story_model.dart';

class StoryViewPage extends StatelessWidget {
  final int index;
  final List<AllUserStoryModel> stories;

  StoryViewPage({super.key, required this.index, required this.stories});
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StoryView(
          storyItems: stories[index].stories,
          controller: controller,
          inline: false,
          repeat: false,
          onStoryShow: (storyItem, index) {
            log("Showing a story");
          },
          onComplete: () {
            if (index < stories.length - 1) {
              context.pushReplacementNamed(
                AppRoute.storyPage,
                extra: {
                  'index': index + 1,
                  'stories': stories,
                },
              );
            } else {
              context.pop();
            }
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
