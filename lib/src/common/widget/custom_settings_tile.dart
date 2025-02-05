import 'package:flutter/material.dart';
import '/src/common/constants/global_variables.dart';

class CustomSettingsTile extends StatelessWidget {
  final Widget? icon;
  final String title;
  final VoidCallback onTap;

  const CustomSettingsTile({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0),
      leading: icon,
      title: Text(
        title,
        style: textTheme(context).titleMedium,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
        color: colorScheme(context).outline.withOpacity(0.4),
      ),
    );
  }
}
