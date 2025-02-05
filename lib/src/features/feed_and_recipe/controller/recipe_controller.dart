import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/utils/image_picker_helper.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/models/recipe_model.dart';
import '../../../models/comment_model.dart';
import '../repository/recipe_repository.dart';

class RecipeController extends ChangeNotifier {
  final RecipeRepository _repository = RecipeRepository();

  bool _isLoading = false;
  bool _loadingNewItems = false;
  bool _firstTimeLoadingFeed = true;
  bool _firstTimeLoadingMyRecipes = true;
  int _currentPage = 1;
  int _totalPage = 1;
  String? _nextPageUrl;

  bool get isLoading => _isLoading;
  bool get firstTimeLoadingFeed => _firstTimeLoadingFeed;
  bool get firstTimeLoadingMyRecipes => _firstTimeLoadingMyRecipes;
  final List<File> _pickedImages = [];
  String _descriptionJson = '';
  final List<Recipe> _recipeList = [];
  List<MyRecipe?> _myRecipeList = [];

  late ScrollController feedScrollController;

  int get currentPage => _currentPage;
  int get totalPage => _totalPage;
  String get descriptionJson => _descriptionJson;
  List<Recipe> get recipeList => _recipeList;
  List<MyRecipe?> get myRecipeList => _myRecipeList;
  List<File> get pickedImages => _pickedImages;

  void updateDescription(String description) {
    _descriptionJson = description;
    notifyListeners();
  }

  void removeImage(int index) {
    _pickedImages.removeAt(index);
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  clearRecipe() {
    _recipeList.clear();
    _currentPage = 1;
    _totalPage = 1;
    _nextPageUrl = null;
  }

  void scrollListener() async {
    final maxScroll = feedScrollController.position.maxScrollExtent;
    final currentScroll = feedScrollController.position.pixels;
    if (!_loadingNewItems) {
      if (currentScroll >= maxScroll - 100) {
        if (_nextPageUrl != null) {
          _loadingNewItems = true;
          await fetchRecipeFeed();
          _loadingNewItems = false;
        }
      }
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

  Future<void> toggleCommentLike({
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool done = await _repository.toggleCommentLike(postId: postId);
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
            profileImage: comment['user ']['profile_image'] ?? '',
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

  Future<void> reportRecipe({
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool done = await _repository.reportRecipe(
        postId: postId,
      );
      if (done) {
        onSuccess('Reported this post');
      } else {
        onError('Failed Report this post');
      }
    } catch (e) {
      onError(e.toString());
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
    required int postId,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
    required String commentMessage,
  }) async {
    try {
      bool done = await _repository.addCommentReply(
          postId: postId, comment: commentMessage);
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

  Future<void> fetchRecipeFeed() async {
    try {
      final response = await _repository.fetchRecipe();
      if (response != null) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data']['data'];
        _recipeList.addAll(data.map((json) => Recipe.fromJson(json)).toList());
        _currentPage = responseBody['data']['current_page'] ?? 1;
        _totalPage = responseBody['data']['last_page'] ?? 1;
        _nextPageUrl = responseBody['data']['next_page_url'];
        if (_currentPage == totalPage) {
          _nextPageUrl = null;
        }
      } else {
        log('Failed to fetch  data');
      }
    } catch (e) {
      log('Error fetching  data: $e');
    } finally {
      _firstTimeLoadingFeed = false;
      notifyListeners();
    }
  }

  Future<void> fetchSearchRecipeFeed(String searchQuery) async {
    try {
      final response =
          await _repository.fetchSearchRecipe(searchQuery: searchQuery);
      if (response != null) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data']['data'];
        _recipeList.addAll(data.map((json) => Recipe.fromJson(json)).toList());
        _currentPage = responseBody['data']['current_page'] ?? 1;
        _totalPage = responseBody['data']['last_page'] ?? 1;
        _nextPageUrl = responseBody['data']['next_page_url'];
        if (_currentPage == totalPage) {
          _nextPageUrl = null;
        }
      } else {
        log('Failed to fetch  data');
      }
    } catch (e) {
      log('Error fetching  data: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMyRecipeFeed() async {
    try {
      final response = await _repository.fetchMyRecipe();
      _myRecipeList = response!;
    } catch (e) {
      log('Error fetching  data: $e');
    } finally {
      _firstTimeLoadingMyRecipes = false;
      notifyListeners();
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

  Future<void> uploadRecipe({
    required String name,
    required String category,
    required String preparationSteps,
    required List<File> images,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      String accessToken = SharedPrefHelper.getAccessToken()!;
      bool isUploaded = await _repository.uploadRecipe(
          accessToken, name, category, preparationSteps, images);
      if (isUploaded) {
        onSuccess('');
      } else {
        onError('Error while uploading recipe, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
    // final ImagePicker picker = ImagePicker();
    // final List<XFile> images = await picker.pickMultiImage();
    // if (images.isNotEmpty) {
    //   _pickedImages.addAll(images.map((image) => File(image.path)));
    //   notifyListeners();
    // }