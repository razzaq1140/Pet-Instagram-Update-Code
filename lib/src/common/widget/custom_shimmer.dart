import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  const CustomShimmer({super.key, this.height, this.width, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Light grey for base color
        highlightColor: Colors.grey[100]!, // Lighter grey for the highlight
        child: Container(
          width: width ?? double.infinity, // Full width
          height: height ?? 200.0,
          // Set the height for the image
          color: Colors.white,
        ),
      ),
    );
  }
}
