import 'dart:developer';

import 'package:flutter/material.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/follower/repository/followers_repositry.dart';
import '../../../models/follow_requests_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowersController extends ChangeNotifier {
  final FollowersRepositry _repository = FollowersRepositry();

  bool isLoading = false;
  bool showMessageButton = false;
  String? errorMessage;
  int followStatus = 0;

  List<FollowRequest> followRequestList = [];

  Future sendFollowAndSendRequest({required int userId}) async {
    isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final response = await _repository.postFollowAndSendRequest(
          accessToken: accessToken, userId: userId);

      if (response != null) {
        followStatus = response['status'];
        await saveFollowStatus(userId, followStatus);
        notifyListeners();

        return response;
      } else {
        errorMessage = 'Failed to send follow request or follow';
        log('Failed to send follow request or follow');
      }
    } catch (e) {
      errorMessage = e.toString();
      log('Error sending follow request or follow: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveFollowStatus(int userId, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'followStatus_$userId',
      status,
    );
  }

  Future<void> loadFollowStatus(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    followStatus = prefs.getInt('followStatus_$userId') ?? 0;
    notifyListeners();
  }

  bool checkMessagebutton() {
    getFollowButtonText();
    return showMessageButton;
  }

  String getFollowButtonText() {
    switch (followStatus) {
      case 1:
        showMessageButton = true;
        return 'Following';
      case 2:
        showMessageButton = true;
        return 'Follower';
      case 3:
        showMessageButton = false;
        return 'Requested';
      default:
        showMessageButton = false;
        return 'Follow';
    }
  }

  Future fetchFollowRequests() async {
    isLoading = true;
    notifyListeners();

    String accessToken = SharedPrefHelper.getAccessToken()!;
    log("accessToken $accessToken");

    try {
      final response =
          await _repository.getFollowRequests(accessToken: accessToken);

      if (response != null) {
        FollowRequestsResponse requestsResponse =
            FollowRequestsResponse.fromJson(response);
        followRequestList = requestsResponse.followRequests;

        final message = response['message'];

        log('message $message');
        showSnackbar(message: message);
      } else {
        errorMessage = 'Failed to fetch followers';
        log('Failed to fetch followers');
      }
    } catch (e) {
      errorMessage = e.toString();
      log('Error fetching followers: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future followRequestResponse({
    int? userId,
    required String followRequestResponse,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      log('accessToken $accessToken');

      final response = await _repository.patchFollowRequestResponse(
          accessToken: accessToken, response: followRequestResponse);

      if (response != null) {
        final message = response['message'];

        log("message $message");

        showSnackbar(message: message);
      } else {
        errorMessage = 'Failed to send response';
        log('Failed to send response');

        showSnackbar(message: errorMessage!);
      }
    } catch (e) {
      errorMessage = e.toString();
      log('Failed to send response: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
