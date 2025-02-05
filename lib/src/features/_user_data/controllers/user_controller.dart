import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '/src/common/constants/static_data.dart';
import '/src/features/_user_data/repository/user_repository.dart';
import '../models/user_profile_model.dart';
import '../../../common/utils/shared_preferences_helper.dart';
import '../models/user_model.dart';

class UserController extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserProfile? _user;
  UserProfile? get user => _user;

  List<UserModel>? _users;
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel>? get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserData() async {
    try {
      final response = await _repository.getUserData();
      if (response != null) {
        _user = response;
        // HomeRepository().setUserStory();
      } else {
        StaticData.accessToken = '';
        log('Failed to fetch user data');
      }
      notifyListeners();
    } catch (e) {
      log('Error fetching user data: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateUserAbout({
    required String username,
    required String name,
    required String dogType,
    required String breed,
    required int age,
    required double weight,
    required String about,
    required File? image,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      bool done = await _repository.updateUserAbout(username, name, dogType,
          breed, age, weight, about, accessToken, image);
      if (done) {
        fetchUserData();
        log('user fetched');
        onSuccess(null);
      } else {
        onError('Failed to upload data, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future fetchUsers({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final fetchedUsers = await _repository.getAllUsersData(
          page: page, accessToken: accessToken);

      if (fetchedUsers != null) {
        _users = fetchedUsers;
      } else {
        _errorMessage = 'Failed to fetch users';
      }
    } catch (e) {
      _errorMessage = 'Error fetching users: $e';
      log(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
