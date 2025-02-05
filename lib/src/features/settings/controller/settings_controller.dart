import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/shared_preferences_helper.dart';
import '/src/features/settings/repositary/settings_repositary.dart';
import '../../_user_data/models/user_profile_model.dart';
import '/src/router/routes.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepositary _repository = SettingsRepositary();
  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? profileSwitch;
  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String currentRole = "user";
  File? _image;
  bool? currentPrivacyStatus;
  List<dynamic> memberships = [];

  File? get image => _image;
  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isSeller => currentRole == 'seller';

// for logo
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      _image = File(selectedImage.path);
      notifyListeners();
    }
  }

  // Fetch the current user's role
  Future fetchCurrentUser() async {
    _isLoading = true;
    try {
      final response = await _repository.getCurrentUser();

      if (response != null && response.containsKey("current_role")) {
        currentRole = response["current_role"];
        notifyListeners();
      } else {
        _errorMessage = 'Failed to fetch current user role';
      }
    } catch (e) {
      _errorMessage = 'Error fetching current user role: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> switchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;
      final result =
          await _repository.postSwitchProfile(accessToken: accessToken);

      if (result.containsKey("error")) {
        _errorMessage = result["error"];

        if (_errorMessage!.contains(
            "You need to purchase a membership before switching to the seller profile.")) {
          // Navigate to Membership Page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pushNamed(AppRoute.membershipPage);
          });
        } else if (_errorMessage == "No valid role found to switch.") {}
      } else if (result.containsKey("current_role")) {
        // Successfully switched roles
        currentRole = result["current_role"];

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error switching profile: $e';
      log(_errorMessage!);
      showSnackbar(message: _errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future fetchMemberships() async {
    _isLoading = true;
    notifyListeners();
    String accessToken = SharedPrefHelper.getAccessToken()!;

    try {
      final response =
          await _repository.getMemberships(accessToken: accessToken);

      if (response != null) {
        memberships = response;
      } else {
        _errorMessage = 'Failed to fetch memberships';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future purchaseMemberShip({required int userId}) async {
    _isLoading = true;
    notifyListeners();
    String accessToken = SharedPrefHelper.getAccessToken()!;

    try {
      final response = await _repository.postPurchaseMemberShip(
          accessToken: accessToken, id: userId);

      if (response != null) {
      } else {
        _errorMessage = 'Failed to purchase membership';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future setupSellerCenter(
      {required String storeName,
      required String ownerName,
      required String storeDetails}) async {
    _isLoading = true;
    notifyListeners();
    String accessToken = SharedPrefHelper.getAccessToken()!;

    try {
      final response = await _repository.postSellerSetupCenter(
          ownerName: ownerName,
          storeDetails: storeDetails,
          storeName: storeName,
          accessToken: accessToken);

      if (response != null) {
        final message = response['message'];
        showSnackbar(message: message);
      } else {
        _errorMessage = 'Failed to setup seller center';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future sellerSetupCenterLogo({
    required File logo,
    required Function(String? message) onSuccess,
    required Function(String error) onError,
    required BuildContext context,
  }) async {
    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      bool? isDone = await _repository.postSellerSetupCenterLogo(
          logo: logo, accessToken: accessToken);

      if (isDone == true) {
        onSuccess(null);
      } else if (isDone == false) {
        onError('Failed to set logo, please try again!');
      } else {
        onError('Try a different logo!');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future togglePrivacy() async {
    _isLoading = true;
    notifyListeners();

    try {
      String accessToken = SharedPrefHelper.getAccessToken()!;

      final response =
          await _repository.updatePrivacy(accessToken: accessToken);

      if (response != null) {
        final message = response['message'];
        currentPrivacyStatus = response['is_private'];

        showSnackbar(message: message);
      } else {
        _errorMessage = 'Failed to change privacy';
        showSnackbar(message: _errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
