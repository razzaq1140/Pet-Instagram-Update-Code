import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/features/home/controller/home_story_controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../common/constants/global_variables.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  VideoPlayerController? videoController;
  late HomeStoryController _homeStoryController;
  @override
  void initState() {
    _homeStoryController =
        Provider.of<HomeStoryController>(context, listen: false);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_homeStoryController.mediaType == 'video') {
        _homeStoryController.initializeVideoPlayer();
      }
    });
  }

  @override
  void dispose() {
    _homeStoryController.removeMedia();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<HomeStoryController>(
            builder: (context, controller, widget) {
          return GestureDetector(
            onTap: () {
              if (controller.mediaType == 'video' &&
                  controller.videoController != null) {
                _homeStoryController.togglePLay();
              }
            },
            child: Stack(
              children: [
                if (controller.mediaType == 'video' &&
                    controller.videoController != null) ...[
                  Center(
                    child: AspectRatio(
                      aspectRatio:
                          controller.videoController!.value.aspectRatio,
                      child: VideoPlayer(controller.videoController!),
                    ),
                  ),
                  if (controller.isPaused)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 44,
                          color: colorScheme(context).surface,
                        ),
                      ),
                    ),
                  if (!controller.isPaused)
                    Positioned(
                      bottom: 16,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => controller.toggleMute(),
                        child: Center(
                          child: Icon(
                            controller.isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            size: 32,
                            color: colorScheme(context).surface,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: VideoProgressIndicator(
                        controller.videoController!,
                        allowScrubbing: true,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ] else if (controller.mediaType == 'image') ...[
                  Image.file(
                    controller.pickedMedia!,
                    height: height,
                    width: width,
                    fit: BoxFit.contain,
                  ),
                ],
                Positioned(
                  top: 20,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      var overlay = context.loaderOverlay;
                      try {
                        // overlay.show();
                        if (!controller.isPaused) {
                          controller.togglePLay();
                        }
                        _homeStoryController.submitOwnStory(
                            file: _homeStoryController.pickedMedia!,
                            mediaType: _homeStoryController.mediaType!,
                            onSuccess: (success) {
                              overlay.hide();
                              context.pop();
                              showSnackbar(message: 'Story Added');
                            },
                            onError: (error) {
                              showSnackbar(
                                  message:
                                      'There was an issue, please try again!',
                                  isError: true);
                              overlay.hide();
                            },
                            context: context);
                      } catch (e) {
                        log('Story error: $e');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme(context).onSurface,
                      ),
                      child: Icon(
                        Icons.done_all_rounded,
                        color: colorScheme(context).onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      _homeStoryController.removeMedia();
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme(context).onSurface,
                      ),
                      child: Icon(
                        Icons.close,
                        color: colorScheme(context).onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
