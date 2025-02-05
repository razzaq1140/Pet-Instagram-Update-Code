import 'dart:convert';
import 'dart:developer';

import '/src/core/api_helper.dart';

class SellerRepository {
  final ApiHelper _apiHelper = ApiHelper();
  final String baseUrl = 'https://pet-insta.nextwys.com/api';

  Future getSellerDashboard({required String accessToken}) async {
    try {
      final response = await _apiHelper.getRequest(
          endpoint: '$baseUrl/seller/dashboard', authToken: accessToken);

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
}
