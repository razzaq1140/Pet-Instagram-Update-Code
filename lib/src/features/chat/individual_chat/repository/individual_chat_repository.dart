import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import '/src/common/constants/static_data.dart';
import '/src/core/api_helper.dart';
import '../../../../core/api_endpoints.dart';
import '../models/chat_room_model.dart';

class IndividualChatRepository {
  final ApiHelper _apiHelper = ApiHelper();
  Future<List<ChatRoomModel>> fetchChats() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: ApiEndpoints.individualChatRoom,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message'].toString());
        List<dynamic> data = responseBody['data'];
        return data.map((json) => ChatRoomModel.fromJson(json)).toList();
      } else {
        log('Failed: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error: $e');
      return [];
    }
  }

  Future<Response?> fetchChatMesages(
      {required String? nextPage, required int chatId}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint:
            '${ApiEndpoints.individualChatRoom}/$chatId${ApiEndpoints.getMessages}',
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

  Future<Map<String, dynamic>> sendMessage(
      {required int otherId, required String message}) async {
    try {
      Map<String, String> data = {
        'message': message,
      };
      final response = await _apiHelper.postRequest(
        endpoint: '${ApiEndpoints.directMessage}$otherId',
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
      {required int otherId, required File image}) async {
    try {
      final response = await _apiHelper.postFileRequest(
        endpoint: '${ApiEndpoints.directMessage}$otherId',
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
      {required int otherId,
      required String message,
      required File image}) async {
    try {
      Map<String, String> data = {
        'message': message,
      };
      final response = await _apiHelper.postFilesWithDataRequest(
        endpoint: '${ApiEndpoints.directMessage}$otherId',
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
}
