import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/router/routes.dart';
import 'package:video_player/video_player.dart';

class StoryItem {
  final String url;
  final bool isVideo;

  StoryItem({required this.url, required this.isVideo});
}

class StatusStoryProvider with ChangeNotifier {
  List<StoryItem> stories = [
    StoryItem(
        url:
            'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        isVideo: false),
    StoryItem(
        url:
            'https://media.istockphoto.com/id/1999341160/video/close-up-of-young-australian-fur-seals-playing-in-clear-blue-open-ocean-water.mp4?s=mp4-640x640-is&k=20&c=XTMiDRR7mH4E4dm1twOkCDdrmviZOZfPsgZIY0aYmkE=',
        isVideo: true),
    StoryItem(
        url:
            'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
        isVideo: false),
    StoryItem(
        url:
            'https://media.istockphoto.com/id/1999341160/video/close-up-of-young-australian-fur-seals-playing-in-clear-blue-open-ocean-water.mp4?s=mp4-640x640-is&k=20&c=XTMiDRR7mH4E4dm1twOkCDdrmviZOZfPsgZIY0aYmkE=',
        isVideo: true),
  ];

  PageController pageController = PageController();
  VideoPlayerController? videoController;

  int currentIndex = 0;
  Timer? timer;
  double progress = 0.0;
  List<double> progressList = [];
  bool isLoading = true;

  StatusStoryProvider() {
    if (stories.isNotEmpty) {
      progressList = List.generate(stories.length, (index) => 0.0);
      _startTimer(stories[currentIndex]);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    videoController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _startTimer(StoryItem currentItem) {
    timer?.cancel();
    progress = 0.0;
    progressList[currentIndex] = 0.0;
    notifyListeners();

    if (currentItem.isVideo) {
      _startVideo(currentItem);
    } else {
      _startImageTimer();
    }
  }

  void _startVideo(StoryItem currentItem) {
    videoController?.dispose();

    videoController =
        VideoPlayerController.networkUrl(Uri.parse(currentItem.url))
          ..initialize().then((_) {
            videoController!.play();
            isLoading = false;
            notifyListeners();

            timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
              if (videoController!.value.isInitialized) {
                final maxTicks =
                    videoController!.value.duration.inMilliseconds / 100;
                progress = timer.tick / maxTicks;
                progressList[currentIndex] = progress;
                notifyListeners();

                if (progress >= 1.0 || !videoController!.value.isPlaying) {
                  nextStory();
                }
              }
            });
          }).catchError((error) {
            log('Video Player Error: $error');
            nextStory();
          });
  }

  void _startImageTimer() {
    isLoading = false;
    notifyListeners();

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      progress = timer.tick / 100; // 10 seconds for the image
      progressList[currentIndex] = progress;
      notifyListeners();

      if (progress >= 1.0) {
        nextStory();
      }
    });
  }

  void nextStory([BuildContext? context]) {
    if (currentIndex < stories.length - 1) {
      timer?.cancel();
      progressList[currentIndex] = 1.0;
      currentIndex++;
      progress = 0.0;
      progressList[currentIndex] = 0.0;
      isLoading = true;
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 300), () {
        pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        _startTimer(stories[currentIndex]);
      });
    } else {
      _finishStories(context);
    }
  }

  void previousStory() {
    if (currentIndex > 0) {
      timer?.cancel();
      progressList[currentIndex] = 0.0;
      currentIndex--;
      progress = 0.0;
      isLoading = true;
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 300), () {
        pageController.previousPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        _startTimer(stories[currentIndex]);
      });
    }
  }

  // Handle when all stories are completed
  void _finishStories(BuildContext? context) {
    timer?.cancel();
    if (context != null) {
      // Ensure navigation is triggered only when context is available
      // ignore: use_build_context_synchronously
      Future.microtask(() => WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pushNamed(AppRoute.navigationBar);
          })); // Navigate to the home page
    } else {
      log('All stories completed, but context was null.');
    }
  }
}
