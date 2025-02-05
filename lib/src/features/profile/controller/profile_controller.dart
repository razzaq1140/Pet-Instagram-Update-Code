import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_project/src/features/profile/repositry/profile_repository.dart';
import '../models/my_post_model.dart';
import '../../../models/comment_model.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  bool _isLoading = false;
  List<MyPostModel> _postList = [];

  bool get isLoading => _isLoading;
  List<MyPostModel> get postList => _postList;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  clearAll() {
    _postList.clear();
    notifyListeners();
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
      _postList = await _repository.fetchPosts();
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
