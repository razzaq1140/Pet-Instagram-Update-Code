import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '/src/features/home/model/post_model.dart';
import '/src/features/home/repository/home_repository.dart';
import '../../../common/utils/image_picker_helper.dart';
import '../../../models/comment_model.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  bool _isLoading = false;
  bool _loadingNewItems = false;
  int _currentPage = 1;
  int _totalPage = 1;
  String? _nextPageUrl;
  final List<PostModel> _postList = [];
  final List<File> _pickedImages = [];
  late ScrollController homePostScrollController;

  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPage => _totalPage;
  List<PostModel> get postList => _postList;
  List<File> get pickedImages => _pickedImages;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  clearAll() {
    _postList.clear();
    notifyListeners();
  }

  void removeImage(int index) {
    _pickedImages.removeAt(index);
    notifyListeners();
  }

  void scrollListener() async {
    final maxScroll = homePostScrollController.position.maxScrollExtent;
    final currentScroll = homePostScrollController.position.pixels;
    if (!_loadingNewItems) {
      if (currentScroll >= maxScroll - 100) {
        if (_nextPageUrl != null) {
          _loadingNewItems = true;
          await fetchPostFeed();
          _loadingNewItems = false;
        }
      }
    }
  }

  Future<void> pickImage(BuildContext context) async {
    ImagePickerHelper.showImageSourceSelection(
      context,
      onTapCamera: () async {
        final XFile? image = await ImagePickerHelper.pickImageFromCamera();
        if (image != null) {
          _pickedImages.add(File(image.path));
          notifyListeners();
        }
      },
      onTapGallery: () async {
        final List<XFile> images = await ImagePickerHelper.pickMultipleImages();
        if (images.isNotEmpty) {
          _pickedImages.addAll(images.map((image) => File(image.path)));
          notifyListeners();
        }
      },
    );
  }

  Future<CommentModel?> addComment({
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
    required String commentMessage,
  }) async {
    try {
      Map<String, dynamic> comment =
          await _repository.addComment(postId: postId, comment: commentMessage);
      if (comment.isNotEmpty) {
        var newComment = CommentModel(
          id: comment['id'] as int,
          content: comment['content'] ?? '',
          createdAt: DateTime.now().toString(),
          likedByUser: false,
          user: CommentUserModel(
            id: comment['user']['id'],
            name: comment['user']['name'] ?? '',
            username: comment['user']['username'] ?? '',
            profileImage: comment['user']['profile_image'] ?? '',
          ),
        );
        onSuccess(null);
        return newComment;
      } else {
        onError('Failed to comment on post, Please try again.');
        return null;
      }
    } catch (e) {
      onError(e.toString());
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleLikeComment({
    required int commentId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      log('message $commentId');
      bool done = await _repository.toggleLikeComment(commentId: commentId);
      if (done) {
        onSuccess(null);
      } else {
        onError('Failed to like post, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> addCommentReply({
    required int commentId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
    required String commentMessage,
  }) async {
    try {
      bool done = await _repository.addCommentReply(
          commentId: commentId, comment: commentMessage);
      if (done) {
        onSuccess(null);
      } else {
        onError('Failed to comment on post, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchPostFeed() async {
    try {
      final Response? response =
          await _repository.fetchPosts(nextPageUrl: _nextPageUrl);
      if (response != null) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data']['data'];
        _postList.addAll(data.map((json) => PostModel.fromJson(json)).toList());
        _currentPage = responseBody['data']['current_page'] ?? 1;
        log('last feed page: ${responseBody['data']['last_page']}');
        _totalPage = responseBody['data']['last_page'] ?? 1;
        _nextPageUrl = responseBody['data']['next_page_url'];
        if (_currentPage == _totalPage) {
          _nextPageUrl = null;
        }
      } else {
        log('Failed to fetch Posts data $response');
      }
    } catch (e, stc) {
      log('Error fetching posts: $e $stc');
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleLike({
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool done = await _repository.toggleLike(postId: postId);
      if (done) {
        onSuccess(null);
      } else {
        onError('Failed to like post, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleSave({
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool done = await _repository.toggleSave(postId: postId);
      if (done) {
        onSuccess(null);
      } else {
        onError('Failed to like post, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> submitAPost({
    required String description,
    required List<File> files,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool isDone =
          await _repository.submitAPost(description: description, files: files);
      if (isDone) {
        onSuccess(null);
      } else {
        onError('Something went wrong. Check your connection');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
