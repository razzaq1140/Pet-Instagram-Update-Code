import 'dart:convert';
import 'dart:developer';
import '/src/core/api_helper.dart';
import '../../../models/other_user_model.dart';

class OtherProfileRepository {
  final ApiHelper apiHelper = ApiHelper();
  final String baseUrl = 'https://pet-insta.nextwys.com/api';

  Future<OtherUserProfile?> getSingleUser({
    required String accessToken,
    required int userId,
  }) async {
    try {
      final response = await apiHelper.getRequest(
        endpoint: '$baseUrl/user/$userId',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return OtherUserProfile.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future getSingleUserFollowing({
    required String accessToken,
    required int userId,
  }) async {
    try {
      final response = await apiHelper.getRequest(
        endpoint: '$baseUrl/user/$userId/following',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future getSingleUserFollowers({
    required String accessToken,
    required int userId,
  }) async {
    try {
      final response = await apiHelper.getRequest(
        endpoint: '$baseUrl/user/$userId/followers',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
