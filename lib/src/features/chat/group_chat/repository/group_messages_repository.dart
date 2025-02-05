import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import '/src/common/constants/static_data.dart';
import '/src/core/api_helper.dart';
import '../../../../core/api_endpoints.dart';
import '../model/group_member_model.dart';

class GroupMessagesRepository {
  final ApiHelper _apiHelper = ApiHelper();
  Future<Response?> fetchMessages(
      {String? nextPage, required int groupId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: nextPage ??
            '${ApiEndpoints.groups}/$groupId${ApiEndpoints.getMessages}',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());

        return response;
      } else {
        log('Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<bool> markAsRead({required int groupId}) async {
    try {
      final response = await _apiHelper.patchRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.markMessagesAsRead}',
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

  Future<List<GroupMemberModel>> fetchMembers({required int groupId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.addMember}',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];

        return data.map((json) => GroupMemberModel.fromJson(json)).toList();
      } else {
        log('Failed: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> sendMessage(
      {required int groupId, required String message}) async {
    try {
      Map<String, String> data = {
        'message': message,
      };
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.groups}/$groupId${ApiEndpoints.getMessages}',
        data: data,
        authToken: StaticData.accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());

        return responseBody['data'];
      } else {
        log('Failed: ${response.body}');
        return {};
      }
    } catch (e) {
      log('Error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> sendImage(
      {required int groupId, required File image}) async {
    try {
      final response = await _apiHelper.postFileRequest(
        endpoint: '${ApiEndpoints.groups}/$groupId${ApiEndpoints.getMessages}',
        key: 'image',
        file: image,
        authToken: StaticData.accessToken,
      );
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseString);
        log(responseData['message'].toString());
        return responseData['data'];
      } else {
        log('Failed: $responseString');
        return {};
      }
    } catch (e) {
      log('Error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> sendMessageWithImage(
      {required int groupId,
      required String message,
      required File image}) async {
    try {
      Map<String, String> data = {
        'message': message,
      };
      final response = await _apiHelper.postFilesWithDataRequest(
        endpoint: '${ApiEndpoints.groups}/$groupId${ApiEndpoints.getMessages}',
        key: 'image',
        files: [image],
        data: data,
        authToken: StaticData.accessToken,
      );

      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseString);
        log(responseData['message'].toString());
        return responseData['data'];
      } else {
        log('Failed: $responseString');
        return {};
      }
    } catch (e) {
      log('Error: $e');
      return {};
    }
  }

  Future<bool> updateGroupInfo({
    required int groupId,
    String? name,
    int? isPrivate,
    String? description,
  }) async {
    try {
      Map<String, dynamic> data = {
        if (name != null) 'name': name,
        if (isPrivate != null) 'is_private': isPrivate,
        if (description != null) 'description': description,
      };
      log(data.toString());
      final response = await _apiHelper.patchRequest(
        endpoint: '${ApiEndpoints.updateGroups}$groupId',
        data: data,
        authToken: StaticData.accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        log(responseBody['data'].toString());

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

  Future<bool> removeMemberFromGroup(
      {required int groupId, required int memberId}) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.addMember}/$memberId',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        log(responseBody['data'].toString());
        log(responseBody.toString());

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

  Future<bool> leaveGroup({required int groupId}) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endpoint:
            '${ApiEndpoints.fetchAllGroups}/$groupId${ApiEndpoints.leaveGroup}',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        log(responseBody['data'].toString());

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

  Future<bool> deleteGroup({required int groupId}) async {
    try {
      final response = await _apiHelper.deleteRequest(
        endpoint: '${ApiEndpoints.fetchAllGroups}/$groupId',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        log(responseBody['data'].toString());

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
