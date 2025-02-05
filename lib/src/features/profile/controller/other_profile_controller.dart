import 'dart:developer';
import 'package:flutter/material.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/profile/repositry/other_profile_repositry.dart';
import '../../../models/followers_model.dart';
import '../../../models/following_model.dart';
import '../../../models/other_user_model.dart';

class OtherProfileController extends ChangeNotifier {
  final OtherProfileRepository _repository = OtherProfileRepository();

  bool isLoading = false;
  String? errorMessage;
  OtherUserProfile? otherUserProfile;
  List<Follower> followers = [];
  List<Following> followings = [];

  Future fetchSingleUser({required int userId}) async {
    isLoading = true;
    notifyListeners();

    String accessToken = SharedPrefHelper.getAccessToken()!;
    log("accessToken $accessToken");

    try {
      final response = await _repository.getSingleUser(
          accessToken: accessToken, userId: userId);

      if (response != null) {
        otherUserProfile = response;
      } else {
        errorMessage = 'Failed to fetch other user data';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future fetchSingleUserFollowing({required int userId}) async {
    isLoading = true;
    notifyListeners();

    String accessToken = SharedPrefHelper.getAccessToken()!;
    log("accessToken $accessToken");

    try {
      final response = await _repository.getSingleUserFollowing(
          accessToken: accessToken, userId: userId);

      if (response != null) {
        FollowingsResponse followingsResponse =
            FollowingsResponse.fromJson(response);
        followings = followingsResponse.followings;
      } else {
        errorMessage = 'Failed to fetch following';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future fetchSingleUserFollowers({required int userId}) async {
    isLoading = true;
    notifyListeners();

    String accessToken = SharedPrefHelper.getAccessToken()!;

    try {
      final response = await _repository.getSingleUserFollowers(
          accessToken: accessToken, userId: userId);

      if (response != null) {
        FollowersResponse followersResponse =
            FollowersResponse.fromJson(response);
        followers = followersResponse.followers;
      } else {
        errorMessage = 'Failed to fetch Followers';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
