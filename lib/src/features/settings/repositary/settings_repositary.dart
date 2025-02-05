import 'dart:convert';
import 'dart:io';
import '/src/core/api_helper.dart';

class SettingsRepositary {
  final ApiHelper _apiHelper = ApiHelper();
  final String baseUrl = 'https://pet-insta.nextwys.com/api';

  Future getCurrentUser() async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: '$baseUrl/profile/current',
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

  Future postSwitchProfile({required String accessToken}) async {
    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/profile/switch',
        authToken: accessToken,
      );
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      return {"error": "An error occurred while switching profiles"};
    }
  }

  Future<List<dynamic>?> getMemberships({required String accessToken}) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: '$baseUrl/admin/memberships',
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody["data"];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future postPurchaseMemberShip(
      {required String accessToken, required int id}) async {
    final data = {
      'membership_id': id,
      'payment_token': 'pm_card_visa',
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/membership/purchase',
        data: data,
        authToken: accessToken,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return {"error": responseBody["error"]};
      }
    } catch (e) {
      return 'An error occurred while purchasing membership.';
    }
  }

  Future postSellerSetupCenter(
      {required String accessToken,
      required String storeName,
      required String ownerName,
      required String storeDetails}) async {
    // data to send
    final data = {
      'store_name': storeName,
      'owner_name': ownerName,
      'store_details': storeDetails,
    };

    try {
      final response = await _apiHelper.postRequest(
        endpoint: '$baseUrl/seller-center/setup',
        data: data,
        authToken: accessToken,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'An error occurred while purchasing membership.';
    }
  }

  Future postSellerSetupCenterLogo(
      {required String accessToken, required File logo}) async {
    try {
      final response = await _apiHelper.postFileRequest(
          endpoint: '$baseUrl/seller-center/store-logo',
          file: logo,
          key: 'store_logo',
          authToken: accessToken);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updatePrivacy({required String accessToken}) async {
    try {
      final response = await _apiHelper.patchRequest(
        endpoint: '$baseUrl/profile/toggle-privacy',
        authToken: accessToken,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        return responseBody;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'An error occurred while updating privacy.';
    }
  }
}
