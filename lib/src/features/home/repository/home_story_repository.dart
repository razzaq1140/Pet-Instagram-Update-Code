import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../../../core/api_endpoints.dart';
import '../../../core/api_helper.dart';
import '../model/story_model.dart';

class HomeStoryRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<StoryModel>> fetchOwnStory() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.getOwnStories,
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        log(responseBody['message']);
        List<dynamic> data = responseBody['data'];
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log('Error : $e');
      return [];
    }
  }

  Future<bool> submitOwnStory(
      {required String mediaType, required File file}) async {
    try {
      final Map<String, String> data = {
        'media_type': mediaType,
        'text_content': '',
      };

      final response = await _apiHelper.postFilesWithDataRequest(
        endpoint: ApiEndpoints.postStory,
        data: data,
        key: 'media',
        files: [file],
      );
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

  Future<List<StoryModel>> fetchFollowersStory() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.getFollowersStories,
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        log(responseBody['message']);
        List<dynamic> data = responseBody['data'];
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log('Error : $e');
      return [];
    }
  }
}
