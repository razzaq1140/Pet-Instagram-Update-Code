import 'dart:convert';
import 'dart:developer';
import '/src/core/api_helper.dart';

class FollowersRepositry {
  final ApiHelper _apiHelper = ApiHelper();
  final String baseUrl = 'https://pet-insta.nextwys.com/api';

  Future postFollowAndSendRequest(
      {required int userId, required String accessToken}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/user/$userId/toggle-follow-send-request',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final message = data['message'];
        final status = data['status'];

        log('message: $message , status: $status');

        log('data $data');
        return data;
      } else if (response.statusCode == 400) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final message = data['message'];
        final status = data['status'];

        log('message: $message , status: $status');
        return data;
      } else {
        log('Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future getFollowRequests({required String accessToken}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: '$baseUrl/follow-requests',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        log('data $data');

        return data;
      } else {
        log('Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future patchFollowRequestResponse({
    int? userId,
    required String accessToken,
    required String response,
  }) async {
//  Request Response to send
    final data = {
      "status": response,
    };

    try {
      final response = await _apiHelper.patchRequest(
        endpoint: '$baseUrl/follow-request/2/respond',
        authToken: accessToken,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'];

        log('respone: $message');

        return responseBody;
      } else {
        log('Failed: ${response.body}');
        return response.body;
      }
    } catch (e) {
      log('Error: $e');
      return 'An error occurred while sending request response.';
    }
  }
}
