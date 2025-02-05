import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '/src/common/utils/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';
import '../../../common/utils/image_picker_helper.dart';
import '../model/story_model.dart';
import '../repository/home_story_repository.dart';
import 'package:path/path.dart' as path;

class HomeStoryController extends ChangeNotifier {
  final HomeStoryRepository _repository = HomeStoryRepository();

  bool _isStoryLoading = false;
  bool _isMyStoryAvailable = false;
  bool _isFollowerStoryLoading = false;
  File? _pickedMedia;
  String _mediaType = 'Unknown';
  bool _isMuted = false;
  bool _isPaused = false;
  VideoPlayerController? videoController;
  final List<AllUserStoryModel> _followersStories = [];

  bool get isStoryLoading => _isStoryLoading;
  bool get isFollowerStoryLoading => _isFollowerStoryLoading;
  bool get isMyStoryAvailable => _isMyStoryAvailable;
  bool get isMuted => _isMuted;
  bool get isPaused => _isPaused;
  String? get mediaType => _mediaType;
  File? get pickedMedia => _pickedMedia;
  List<AllUserStoryModel> get followersStories => _followersStories;

  void toggleLoading() {
    _isStoryLoading = !_isStoryLoading;
    notifyListeners();
  }

  void toggleFollowerStoryLoading() {
    _isFollowerStoryLoading = !_isFollowerStoryLoading;
    notifyListeners();
  }

  void removeMedia() {
    _pickedMedia = null;
    _mediaType = 'Unknown';
    videoController?.removeListener(videoControllerListener);
    videoController = null;
  }

  clearAll() {
    _followersStories.clear();
    notifyListeners();
  }

  void initializeVideoPlayer() {
    videoController = VideoPlayerController.file(_pickedMedia!)
      ..initialize().then((_) {
        _isPaused = false;
        videoController!.play();
        notifyListeners();
        videoController!.addListener(videoControllerListener);
      });
  }

  void videoControllerListener() {
    if (videoController!.value.isCompleted) {
      _isPaused = true;
      videoController!.pause();
      notifyListeners();
    }
  }

  void togglePLay() {
    _isPaused = !_isPaused;
    if (_isPaused) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      videoController!.setVolume(0.0);
    } else {
      videoController!.setVolume(1.0);
    }
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context, VoidCallback onPicked) async {
    ImagePickerHelper.showImageSourceSelection(
      context,
      onTapCamera: () async {
        try {
          final XFile? image = await ImagePickerHelper.pickImageFromCamera();
          if (image != null) {
            _pickedMedia = File(image.path);
            _mediaType = 'image';
            onPicked();
            notifyListeners();
          }
        } catch (e) {
          showSnackbar(
              message: 'There was an issue, Please try again', isError: true);
        }
      },
      onTapGallery: () async {
        try {
          final XFile? media = await ImagePickerHelper.pickMediaFromGallery();
          if (media != null) {
            _pickedMedia = File(media.path);
            _mediaType = _getFileType(media.path);
            onPicked();
            notifyListeners();
          }
        } catch (e) {
          showSnackbar(
              message: 'There was an issue, Please try again', isError: true);
        }
      },
    );
  }

  Future<void> fetchOwnStory() async {
    try {
      toggleLoading();
      final response = await _repository.fetchOwnStory();
      if (response.isNotEmpty) {
        _isMyStoryAvailable = true;
        List<StoryItem> myStories = response.map((story) {
          StoryController controller = StoryController();
          if (story.mediaType == 'video') {
            return StoryItem.pageVideo(
              story.mediaUrl,
              controller: controller,
            );
          }
          return StoryItem.pageImage(
            url: story.mediaUrl,
            controller: controller,
          );
        }).toList();
        StoryUserModel currentUser = response.first.user;
        _followersStories.insert(
            0, AllUserStoryModel(user: currentUser, stories: myStories));
      } else {
        _isMyStoryAvailable = false;
        log('no Stories found: $response');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    } finally {
      toggleLoading();
      notifyListeners();
    }
  }

  Future<void> submitOwnStory({
    required File file,
    required String mediaType,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      if (_mediaType == 'Unknown') {
        showSnackbar(message: 'Invalid file type.', isError: true);
        return;
      }
      bool isDone =
          await _repository.submitOwnStory(mediaType: mediaType, file: file);
      if (isDone) {
        onSuccess(null);
        await fetchOwnStory();
      } else {
        onError('Something went wrong. Check your connection');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchFollowersStory() async {
    try {
      toggleFollowerStoryLoading();
      _followersStories.clear();
      final response = await _repository.fetchFollowersStory();
      if (response.isNotEmpty) {
        List<int> userIds = response
            .map((story) {
              return story.userId;
            })
            .toSet()
            .toList();

        for (int id in userIds) {
          List<StoryItem> storyList =
              response.where((story) => story.userId == id).map((story) {
            StoryController controller = StoryController();
            if (story.mediaType == 'video') {
              return StoryItem.pageVideo(
                story.mediaUrl,
                controller: controller,
              );
            }
            return StoryItem.pageImage(
              url: story.mediaUrl,
              controller: controller,
            );
          }).toList();
          StoryUserModel user = response[response
                  .indexOf(response.firstWhere((story) => story.userId == id))]
              .user;

          if (storyList.isNotEmpty) {
            _followersStories
                .add(AllUserStoryModel(user: user, stories: storyList));
          }
        }
      } else {
        log('no follower Story found: $response');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    } finally {
      toggleFollowerStoryLoading();
      notifyListeners();
    }
  }

  String _getFileType(String filePath) {
    // Get the file extension from the picked file path
    String extension = path.extension(filePath).toLowerCase();

    // Determine the type based on the extension
    if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(extension)) {
      return 'image';
    } else if (['.mp4', '.mov', '.avi', '.mkv', '.flv', '.webm']
        .contains(extension)) {
      return 'video';
    } else {
      return 'Unknown'; // In case the extension is not recognized
    }
  }
}
