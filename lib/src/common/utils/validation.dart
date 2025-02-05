import 'package:easy_localization/easy_localization.dart';

class Validation {
  static String? emailOrUsernameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email or username.';
    }

    // Check if the value is a valid email format
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]{2,4}$';
    RegExp emailRegex = RegExp(emailPattern);

    // Check if the value is a valid username (alphanumeric, length between 3 and 20 characters)
    String usernamePattern = r'^[a-zA-Z0-9_]{3,20}$';
    RegExp usernameRegex = RegExp(usernamePattern);

    if (emailRegex.hasMatch(value.trim())) {
      // It's a valid email
      return null;
    } else if (usernameRegex.hasMatch(value.trim())) {
      // It's a valid username
      return null;
    } else {
      // Invalid email and username
      return 'Please enter a valid email or username.';
    }
  }

  static String? fieldValidation(String? value, String field) {
    if (value!.isEmpty) {
      return '${'please_enter'.tr()} $field';
    }
    return null;
  }

  static String? emailValidation(String? value) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim())) {
      return 'enter_valid_email'.tr();
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value!.isEmpty) {
      return 'please_enter_password'.tr();
    }
    if (value.length < 8) {
      return 'At least eight Characters'.tr();
    }
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'at_least_one_uppercase'.tr();
    // }
    // if (!value.contains(RegExp(r'[a-z]'))) {
    //   return 'at_least_one_lowercase'.tr();
    // }
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'at_least_one_digit'.tr();
    // }
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'at_least_one_special_character'.tr();
    // }
    return null;
  }

  static String? confirmPassword(String? value, String confirm) {
    if (value != confirm) {
      return 'password_dont_match'.tr();
    } else if (passwordValidation(value) != null) {
      return passwordValidation(value);
    }
    return null;
  }

  static String? phoneNumberValidation(String? value) {
    if (value!.isEmpty) {
      return 'enter_ph_no'.tr();
    }
    RegExp regex = RegExp(r'^\+\d{1,3}\d{10,14}$');
    if (!regex.hasMatch(value)) {
      return 'invalid_ph_no_format'.tr();
    }
    return null;
  }

  static String? cardNumberValidation(String? value) {
    if (value!.isEmpty) {
      return 'enter_card_no'.tr();
    }
    RegExp regex = RegExp(r'^\d{4}\s\d{4}\s\d{4}\s\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'enter_valid_card_no'.tr();
    }
    return null;
  }

  static String? expiryDateValidation(String? value) {
    if (value!.isEmpty) {
      return 'enter_expiry_date'.tr();
    }
    RegExp regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'enter_valid_expiry_date'.tr();
    }
    return null;
  }

  static String? cvvValidation(String? value) {
    if (value!.isEmpty) {
      return 'enter_cvv_no'.tr();
    }
    RegExp regex = RegExp(r'^\d{3}$');
    if (!regex.hasMatch(value)) {
      return 'enter_valid_cvv_no'.tr();
    }
    return null;
  }

  static String? numberValidation(String? value, {String field = "number"}) {
    if (value == null || value.isEmpty) {
      return '${'please_enter_a'.tr()} $field';
    }
    // Regular expression to check if the input is only digits
    RegExp regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value)) {
      return '${'please_enter_a_valid'.tr()} $field (${'only_digit'.tr()})';
    }
    return null;
  }

  static String? ageValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_age'.tr();
    }
    RegExp regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value)) {
      return 'please_enter_valid_age'.tr();
    }
    int age = int.parse(value);
    if (age < 0 || age > 30) {
      return 'age_must_be_between_0_and_30'.tr();
    }
    return null;
  }

  static String? weightValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_weight'.tr();
    }

    // Updated regex to allow decimal numbers
    RegExp regex = RegExp(r'^\d+(\.\d+)?$');
    if (!regex.hasMatch(value)) {
      return 'please_enter_valid_weight'.tr();
    }

    double weight = double.parse(value); // Parsing the value as a double
    if (weight < 0 || weight > 200) {
      return 'weight_must_be_between_0_and_200'.tr();
    }

    return null;
  }
}
