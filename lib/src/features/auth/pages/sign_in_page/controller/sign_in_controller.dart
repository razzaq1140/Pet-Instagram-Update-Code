import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '/src/features/auth/pages/sign_in_page/repositary/sign_in_repositary.dart';
import '../../../../_user_data/models/user_profile_model.dart';

class SignInController extends ChangeNotifier {
  final SignInRepositary _repository = SignInRepositary();
  bool _rememberMe = false;
  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _fcmToken;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      toggleLoading();
      await getFCMToken();
      log(_fcmToken.toString());
      bool isLogin = await _repository.loginUser(
          email,
          password,
          _fcmToken ??
              "cSkTRshzS9Gxz2ngVVHir6:APA91bGKFIjKgOOv--P3semoiC-miX1ugmI125sd70oo_iHobBNUP3J-u0FaJMvpttLYOaUFjrWkGjKOapkOoFTtW6dHusiRozoClmTgjMmnP_8IgPsmFR8");
      if (isLogin) {
        onSuccess('Login Successfully');
      } else {
        onError('Error while login account, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      toggleLoading();
      notifyListeners();
    }
  }

  Future<void> getFCMToken() async {
    _fcmToken = await FirebaseMessaging.instance.getToken();
  }

  Future<void> sendPasswordResetOtp({
    required String email,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      toggleLoading();

      log(_fcmToken.toString());
      String message = await _repository.sendPasswordResetOtp(
        email: email,
      );
      if (message.isEmpty) {
        onSuccess('Otp Successfully sent');
      } else {
        onError(message);
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      toggleLoading();
      notifyListeners();
    }
  }

  Future<void> verifyOtp({
    required String email,
    required num otpCode,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      bool isOtpVerified =
          await _repository.verifyOtp(email: email, otpCode: otpCode);
      if (isOtpVerified) {
        onSuccess('OTP has been verified');
      } else {
        onError('Invalid OTP, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required num otpCode,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      toggleLoading();

      await getFCMToken();
      bool isRegister = await _repository.resetPassword(
          email: email,
          otpCode: otpCode,
          password: password,
          fcmToken: _fcmToken ??
              "cSkTRshzS9Gxz2ngVVHir6:APA91bGKFIjKgOOv--P3semoiC-miX1ugmI125sd70oo_iHobBNUP3J-u0FaJMvpttLYOaUFjrWkGjKOapkOoFTtW6dHusiRozoClmTgjMmnP_8IgPsmFR8");
      if (isRegister) {
        onSuccess('Password reset successfully!');
      } else {
        onError('Error while account creation, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      toggleLoading();
      notifyListeners();
    }
  }
}
