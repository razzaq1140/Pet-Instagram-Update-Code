import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '/src/common/constants/static_data.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/core/api_endpoints.dart';
import '/src/core/api_helper.dart';
import '/src/features/auth/pages/sign_up_page/helper/otp_response_helper.dart';

class SignUpRepositary {
  final ApiHelper _apiHelper = ApiHelper();

  Future<OtpResponse> sendOtp(String email) async {
    String? message;
    try {
      final data = {
        'email': email,
      };

      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.sendOtp,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        message = responseBody["message"];
        log('OTP sent successfully to $email');
        return OtpResponse(success: true, mesage: message);
      } else {
        message = response.body;
        log('Failed to send OTP: $message');
        return OtpResponse(success: false, mesage: message);
      }
    } catch (e) {
      log('Error sending OTP: $e');
      return OtpResponse(success: false, mesage: message);
    }
  }

  Future<bool> verifyOtp(String email, num otpCode) async {
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

  Future<bool> registerUser(
      String email, num otpCode, String password, String fcmToken) async {
    try {
      final data = {
        // 'name': 'talha',
        'email': email,
        'password': password,
        'otp': otpCode,
        'fcm_token': fcmToken
      };
      log(fcmToken);
      final response = await _apiHelper.postRequest(
        endpoint: ApiEndpoints.register,
        data: data,
      );

      if (response.statusCode == 302) {
        log('Redirecting to: ${response.headers['location']}');
        log('Response: ${response.body}');
        return false;
      }

      if (response.statusCode == 200) {
        log('verified $email');
        final responseBody = jsonDecode(response.body);

        String accessToken = responseBody['access_token'];
        log('accessToken $accessToken');

        StaticData.accessToken = accessToken;
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

  Future<bool?> setName(String name, String accessToken) async {
    try {
      final data = {
        'username': name,
      };
      final response = await _apiHelper.postRequest(
          endpoint: ApiEndpoints.setUserName,
          data: data,
          authToken: accessToken);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 302) {
        // showSnackbar(message: 'Try a different username!', isError: true);
        return null;
      } else {
        log('Failed : ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> setUerProfileImage(File image, String accessToken) async {
    try {
      log(accessToken);
      final response = await _apiHelper.postFileRequest(
        endpoint: ApiEndpoints.setUserProfileImage,
        file: image,
        key: 'profile_image',
        authToken: accessToken,
      );
      log('${response.statusCode}');
      log(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error : $e');
      return false;
    }
  }

  Future<bool> setUserAbout(String name, String petType, String breed, int age,
      double weight, String about, String accessToken) async {
    try {
      final data = {
        'name': name,
        "about": about,
        'dog_type': petType,
        'breed': breed,
        'age': age,
        "weight": weight,
      };

      log('$data');
      final response = await _apiHelper.postRequest(
          endpoint: ApiEndpoints.setUserAbout,
          data: data,
          authToken: accessToken);

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
