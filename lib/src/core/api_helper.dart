import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import '/src/common/constants/static_data.dart';

class ApiHelper {
  final Duration _timeoutDuration = const Duration(seconds: 30);

  Future<Response> postRequest({
    required String endpoint,
    dynamic data,
    String? authToken,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: $headers');

    try {
      final Response response = await post(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(_timeoutDuration);

      log('RESPONSE: ${response.statusCode} ${response.body}');
      return response;
    } catch (e, stackTrace) {
      log('Error during POST request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<StreamedResponse> postFileRequest({
    required String endpoint,
    required String key,
    required File file,
    Map<String, String>? data,
    required String authToken,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'multipart/form-data',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: ${StaticData.accessToken}');
    log('Headers: $headers');

    try {
      final request = MultipartRequest(
        'POST',
        Uri.parse(endpoint),
      );
      if (data != null) {
        request.fields.addEntries(data.entries);
      }
      request.headers.addEntries(headers.entries);
      request.files.add(await MultipartFile.fromPath(key, file.path));
      final response = await request.send();
      return response;
    } catch (e, stackTrace) {
      log('Error during POST request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<StreamedResponse> postFilesWithDataRequest({
    required String endpoint,
    required String key,
    required List<File> files,
    required Map<String, String> data,
    String? authToken,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${StaticData.accessToken}',
      'Content-Type': 'multipart/form-data',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: $headers');

    try {
      final request = MultipartRequest(
        'POST',
        Uri.parse(endpoint),
      );
      request.headers.addEntries(headers.entries);
      for (File file in files) {
        var filename = file.path.split("/").last;

        request.files.add(
            await MultipartFile.fromPath(key, file.path, filename: filename));
      }
      request.fields.addEntries(data.entries);
      final response = await request.send();
      return response;
    } catch (e, stackTrace) {
      log('Error during POST request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Response> getRequest({
    required String endpoint,
    String? authToken,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${authToken ?? StaticData.accessToken}',
      'Content-Type': 'application/json',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: $headers');
    try {
      final Response response = await get(Uri.parse(endpoint), headers: headers)
          .timeout(_timeoutDuration);
      return response;
    } catch (e, stackTrace) {
      log('Error while GET request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Response> patchRequest({
    required String endpoint,
    dynamic data,
    String? authToken,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: $headers');
    try {
      Response response = await patch(
        Uri.parse(endpoint),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(_timeoutDuration);

      log('RESPONSE: ${response.statusCode} ${response.body}');

      return response;
    } catch (e, stackTrace) {
      log('Error during PATCH request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Response> deleteRequest({
    required String endpoint,
    dynamic data,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${StaticData.accessToken}',
    };

    log('REQUEST TO : $endpoint');
    log('Headers: $headers');
    try {
      Response response = await delete(
        Uri.parse(endpoint),
        headers: headers,
      ).timeout(_timeoutDuration);

      log('RESPONSE: ${response.statusCode} ${response.body}');

      return response;
    } catch (e, stackTrace) {
      log('Error during DELETE request: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
