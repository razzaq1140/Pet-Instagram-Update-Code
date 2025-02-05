import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/constants/app_colors.dart';
import '/src/common/constants/global_variables.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Function to capture an image from the camera
  static Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      return image;
    } catch (e) {
      rethrow;
    }
  }

  // Function to pick single images from the gallery
  static Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      rethrow;
    }
  }

  // Function to pick multiple images from the gallery
  static Future<List<XFile>> pickMultipleImages() async {
    try {
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final List<XFile>? images = await _picker.pickMultiImage();
      return images ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // Function to pick multiple videos from the gallery
  static Future<XFile?> pickMediaFromGallery() async {
    try {
      final XFile? image = await _picker.pickMedia();
      return image;
    } catch (e) {
      rethrow;
    }
  } // Function to pick multiple videos from the gallery
  // static Future<XFile?> pickVideoFromCamera() async {
  //   try {
  //     final XFile? image = await _picker.;
  //     return image;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Function to show the image selection dialog
  static void showImageSourceSelection(
    BuildContext context, {
    required void Function() onTapCamera,
    required void Function() onTapGallery,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option',
              style: textTheme(context)
                  .titleSmall
                  ?.copyWith(color: colorScheme(context).onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColor.appBlue,
                ),
                title: Text('Capture Image',
                    style: textTheme(context)
                        .bodyMedium
                        ?.copyWith(color: AppColor.hintText)),
                onTap: () {
                  Navigator.pop(context);
                  onTapCamera();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.image_outlined,
                  color: AppColor.appBlue,
                ),
                title: Text('Upload from Gallery',
                    style: textTheme(context)
                        .bodyMedium
                        ?.copyWith(color: AppColor.hintText)),
                onTap: () {
                  Navigator.pop(context);
                  onTapGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showFullScreenImage(
      {required BuildContext context,
      required XFile image,
      required void Function() onDelete}) {
    final imagePath = image.path;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                          backgroundColor: colorScheme(context).primary),
                      icon: Icon(Icons.close,
                          color: colorScheme(context).surface, size: 25),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDelete();
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: colorScheme(context).primary),
                      icon: Icon(Icons.delete,
                          color: colorScheme(context).surface, size: 30),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
