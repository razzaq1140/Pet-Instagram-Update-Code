import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon? icon;

  const CustomBackButton({super.key, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ?? () => context.pop(context), // Default action to go back
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 0.6),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.56),
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}
