import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart';
import '/src/common/constants/static_data.dart';
import '/src/core/api_endpoints.dart';
import '/src/core/api_helper.dart';

class HomeRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response?> fetchPosts({String? nextPageUrl}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: nextPageUrl ?? ApiEndpoints.getPostFeed,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      log('Error : $e');
      return null;
    }
  }

  Future<bool> toggleLike({required int postId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.getAPost}$postId${ApiEndpoints.toggleLike}',
        authToken: StaticData.accessToken,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> toggleSave({required int postId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.getAPost}$postId${ApiEndpoints.toggleSave}',
        authToken: StaticData.accessToken,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> addComment(
      {required int postId, required String comment}) async {
    try {
      final data = {
        'comment': comment,
      };
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.getAPost}$postId${ApiEndpoints.comment}',
        authToken: StaticData.accessToken,
        data: data,
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        log(responseBody['comment']['id'].toString());
        return responseBody['comment'] as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      log('Error : $e');
      return {};
    }
  }

  Future<bool> toggleLikeComment({required int commentId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint:
            '${ApiEndpoints.postComments}$commentId${ApiEndpoints.toggleLike}',
        authToken: StaticData.accessToken,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> addCommentReply(
      {required int commentId, required String comment}) async {
    try {
      final data = {
        'comment': comment,
      };
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.postComments}$commentId${ApiEndpoints.reply}',
        authToken: StaticData.accessToken,
        data: data,
      );
      if (response.statusCode == 200) {
        log(' comment response...........$response');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> submitAPost(
      {required String description, required List<File> files}) async {
    try {
      final Map<String, String> data = {
        'caption': description,
      };

      final response = await _apiHelper.postFilesWithDataRequest(
        endpoint: ApiEndpoints.submitAPost,
        data: data,
        key: 'media[]',
        files: files,
      );

      // final response = await request.send();
      log(response.statusCode.toString());
      log(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }
}
