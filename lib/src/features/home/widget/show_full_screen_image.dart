import 'dart:io';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class FullScreenImageViewer extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;

  const FullScreenImageViewer({super.key, this.imageFile, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          imageFile != null
              ? Image.file(imageFile!,
                  fit: BoxFit.contain) // Display local file
              : Image.network(
                  imageUrl!,
                  height: height,
                  width: width,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => PersistentNavBarNavigator.pop(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
