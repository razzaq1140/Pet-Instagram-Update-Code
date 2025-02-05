import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '/src/common/constants/static_data.dart';
import '/src/core/api_helper.dart';

import '../../../../core/api_endpoints.dart';
import '../../../follower/models/follower_model.dart';
import '../model/joined_chat_group_model.dart';

class GroupChatRepository {
  final ApiHelper _apiHelper = ApiHelper();
  Future<List<JoinedChatGroupModel>> fetchGroups() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.fetchMyGroups,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        List<dynamic> data = responseBody['data'];
        return data.map((json) => JoinedChatGroupModel.fromJson(json)).toList();
      } else {
        log('Failed: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  Future<int?> createGroup(
      {required String name,
      required bool isPrivate,
      required String description}) async {
    try {
      final data = {
        'name': name,
        'is_private': isPrivate,
        'description': description
      };

      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.groups,
        data: data,
        authToken: StaticData.accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        return responseBody['data']['id'] as int;
      } else {
        log('Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<bool> addMember({required List<int> ids, required int groupId}) async {
    try {
      final data = {
        'user_ids': ids,
      };

      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.groups}/$groupId${ApiEndpoints.addMember}',
        data: data,
        authToken: StaticData.accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());

        return true;
      } else {
        log('Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }

  Future<String> addGroupIcon(
      {required int groupId, required File file}) async {
    try {
      final response = await _apiHelper.postFileRequest(
        endpoint: '${ApiEndpoints.group}$groupId${ApiEndpoints.setGroupIcon}',
        authToken: StaticData.accessToken,
        file: file,
        key: 'icon',
      );

      if (response.statusCode == 200) {
        var json = await response.stream.bytesToString();
        var decoded = jsonDecode(json);
        log(decoded['icon_url'].toString());
        String iconUrl = decoded['icon_url'] ?? '';

        if (iconUrl.contains('public')) {
          return iconUrl;
        } else {
          final updatedUrl = iconUrl.replaceAll('uploads', 'public/uploads');
          return updatedUrl;
        }
      } else {
        log('Failed: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      log('Error: $e');
      return '';
    }
  }

  Future<List<FollowerModel>> fetchFollowers({required int userId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: '${ApiEndpoints.baseUser}$userId${ApiEndpoints.getFollowers}',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['followers'];

        return data.map((json) => FollowerModel.fromJson(json)).toList();
      } else {
        log('Failed: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  Future<List<FollowerModel>> fetchFollowing({required int userId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: '${ApiEndpoints.baseUser}$userId${ApiEndpoints.getFollowing}',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['following'];

        return data.map((json) => FollowerModel.fromJson(json)).toList();
      } else {
        log('Failed: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  Future<bool> togglePin({required int groupId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.togglePin}',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite({required int groupId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.toggleFavorite}',
      );

      if (response.statusCode == 200) {
        log(response.toString());
        return true;
      } else {
        log('Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }

  Future<bool> joinGroup({required int groupId}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.group}$groupId${ApiEndpoints.joinGroup}',
        authToken: StaticData.accessToken,
      );

      if (response.statusCode == 200) {
        log(response.toString());
        return true;
      } else {
        log('Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }
}
