import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import '/src/common/constants/static_data.dart';
import '/src/common/utils/shared_preferences_helper.dart';

import '/src/core/api_endpoints.dart';
import '/src/core/api_helper.dart';
import '/src/models/recipe_model.dart';

class RecipeRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<bool> uploadRecipe(
    String accessToken,
    String name,
    String category,
    String preparationSteps,
    List<File> images,
  ) async {
    try {
      var uri = Uri.parse(ApiEndpoints.uploadRecipe);
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['preparation_steps'] = preparationSteps;

      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]',
            image.path,
            filename: basename(image.path),
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        log('Recipe uploaded successfully');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        log('Failed: $responseBody');
        return false;
      }
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }

  Future<Response?> fetchRecipe({String? nextPageUrl}) async {
    try {
      final accessToken = SharedPrefHelper.getAccessToken();

      final response = await _apiHelper.getRequest(
        endpoint: nextPageUrl ?? ApiEndpoints.getRecipe,
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        log('Response code: ${response.statusCode}');
        log('Response: ${jsonDecode(response.body)['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      log('Error fetching recipes: $e', stackTrace: stackTrace);
      return null;
    }
  }

  Future<Response?> fetchSearchRecipe(
      {String? nextPageUrl, required String searchQuery}) async {
    try {
      final accessToken = SharedPrefHelper.getAccessToken();

      final response = await _apiHelper.getRequest(
        endpoint:
            nextPageUrl ?? '${ApiEndpoints.getRecipe}?search=$searchQuery',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        log('Response code: ${response.statusCode}');
        log('Response: ${jsonDecode(response.body)['message']}');
        return null;
      }
    } catch (e, stackTrace) {
      log('Error fetching recipes: $e', stackTrace: stackTrace);
      return null;
    }
  }

  Future<List<MyRecipe>?> fetchMyRecipe() async {
    try {
      final accessToken = SharedPrefHelper.getAccessToken();

      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.userRecipe,
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message']);

        final data = responseBody['data'];

        if (data is List) {
          return data.map((json) => MyRecipe.fromJson(json)).toList();
        } else if (data is Map<String, dynamic>) {
          log('$data');
          return [MyRecipe.fromJson(data)];
        } else if (data == []) {
          log('$data');
          return null;
        }
      }
    } catch (e, stackTrace) {
      log('Error fetching recipes: $e', stackTrace: stackTrace);
      return null;
    }
    return null;
  }

  Future<bool> toggleLike({required int postId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.recipe}$postId${ApiEndpoints.toggleLike}',
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

  Future<bool> toggleCommentLike({required int postId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.baseUrl}/recipe-comments/$postId/like',
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

  Future<bool> reportRecipe({
    required int postId,
  }) async {
    try {
      final data = {"recipe_id": postId, 'reason': 'Spam content'};
      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.reportRecipe,
        authToken: StaticData.accessToken,
        data: data,
      );
      if (response.statusCode == 200) {
        log('report response...........$response');
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
        endpoint: '${ApiEndpoints.recipe}$postId${ApiEndpoints.comment}',
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
            '${ApiEndpoints.recipeCommentForLike}$commentId${ApiEndpoints.likeRecipeComment}',
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
      {required int postId, required String comment}) async {
    try {
      final data = {
        'comment': comment,
      };
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.recipe}$postId${ApiEndpoints.comment}',
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

  Future<bool> toggleSave({required int postId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.recipe}$postId${ApiEndpoints.toggleSave}',
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
}
