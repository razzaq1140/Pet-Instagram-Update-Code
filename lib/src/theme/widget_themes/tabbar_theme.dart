import 'package:flutter/material.dart';

import '../color_scheme.dart';

TabBarTheme get tabBarTheme => TabBarTheme(
      labelColor: colorSchemeLight.primary, // Color for selected tab label
      unselectedLabelColor: colorSchemeLight.onSurface
          .withOpacity(0.4), 
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 4.0,
          color:
              colorSchemeLight.primary, 
        ),
        insets: const EdgeInsets.symmetric(horizontal: 0), 
      ),
      indicatorColor: colorSchemeLight.primary,
    );
