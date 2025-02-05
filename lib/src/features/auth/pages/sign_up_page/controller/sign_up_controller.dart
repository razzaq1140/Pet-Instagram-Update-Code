import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/auth/pages/sign_up_page/helper/otp_response_helper.dart';
import '/src/features/auth/pages/sign_up_page/repository/sign_up_repositary.dart';
import '../../../../_user_data/models/user_profile_model.dart';

class SignUpController extends ChangeNotifier {
  final SignUpRepositary _repository = SignUpRepositary();

  String? _fcmToken;

  File? _image;
  File? get image => _image;
  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      _image = File(selectedImage.path);
      notifyListeners();
    }
  }

  Future<void> sendOpt({
    required String email,
    required Function(String message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      OtpResponse isOtpSent = await _repository.sendOtp(email);
      if (isOtpSent.success) {
        onSuccess('OTP sent successfully to $email');
      } else {
        onError('${isOtpSent.mesage}');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> verifyOtp(
      {required String email,
      required Function(String message) onSuccess,
      required Function(String error) onError,
      required BuildContext context,
      required num otpCode}) async {
    try {
      bool isOtpVerified = await _repository.verifyOtp(email, otpCode);
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

  Future<void> registerUser(
      {required String email,
      required String password,
      required Function(String message) onSuccess,
      required Function(String error) onError,
      required BuildContext context,
      required num otpCode}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await getFCMToken();
      bool isRegister = await _repository.registerUser(
          email,
          otpCode,
          password,
          _fcmToken ??
              "cSkTRshzS9Gxz2ngVVHir6:APA91bGKFIjKgOOv--P3semoiC-miX1ugmI125sd70oo_iHobBNUP3J-u0FaJMvpttLYOaUFjrWkGjKOapkOoFTtW6dHusiRozoClmTgjMmnP_8IgPsmFR8");
      if (isRegister) {
        onSuccess('Account Created Successfully');
      } else {
        onError('Error while account creation, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFCMToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      log('FCM Error: $e');
    }
  }

  Future<void> userName({
    required String name,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      bool? isDone = await _repository.setName(name, accessToken);
      if (isDone == true) {
        onSuccess(null);
      } else if (isDone == false) {
        onError('Failed to set name, please try again!');
      } else {
        onError('Try a different username!');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> setUserProfileImage({
    required File image,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      bool? isDone = await _repository.setUerProfileImage(image, accessToken);
      if (isDone == true) {
        onSuccess(null);
      } else if (isDone == false) {
        onError('Failed to set Image, please try again!');
      } else {
        onError('Try a different username!');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> setUserAbout({
    required String name,
    required String dogType,
    required String breed,
    required int age,
    required double weight,
    required String about,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      bool done = await _repository.setUserAbout(
          name, dogType, breed, age, weight, about, accessToken);
      if (done) {
        onSuccess(null);
      } else {
        onError('Failed to upload data, Please try again.');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
