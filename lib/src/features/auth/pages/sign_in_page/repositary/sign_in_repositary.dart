import 'dart:convert';
import 'dart:developer';
import '/src/core/api_helper.dart';
import '../../../../../common/utils/shared_preferences_helper.dart';
import '../../../../../core/api_endpoints.dart';

class SignInRepositary {
  final ApiHelper _apiHelper = ApiHelper();
  Future<bool> loginUser(String email, String password, fcmToken) async {
    try {
      log(fcmToken);
      final data = {
        'username': email,
        'password': password,
        'fcm_token': fcmToken
      };

      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.login,
        data: data,
      );

      if (response.statusCode == 200) {
        log('verified $email');
        final responseBody = jsonDecode(response.body);

        String accessToken = responseBody['access_token'];

        await SharedPrefHelper.saveAccessToken(accessToken);

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

  Future<String> sendPasswordResetOtp({required String email}) async {
    try {
      final data = {
        'email': email,
      };

      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.forgotPassword,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message']);
        return '';
      } else {
        final responseBody = jsonDecode(response.body);
        log(responseBody['message']);
        return responseBody['message'];
      }
    } catch (e) {
      log('Error: $e');
      return e.toString();
    }
  }

  Future<bool> verifyOtp({required String email, required num otpCode}) async {
    try {
      final data = {'email': email, "otp": otpCode};

      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.verifyOtp,
        data: data,
      );

      if (response.statusCode == 200) {
        log('verified $email');
        return true;
      } else {
        log('Failed : ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required num otpCode,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'otp': otpCode,
        'fcm_token': fcmToken
      };
      log(fcmToken);
      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.passwordReset,
        data: data,
      );

      if (response.statusCode == 200) {
        log('verified $email');
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
