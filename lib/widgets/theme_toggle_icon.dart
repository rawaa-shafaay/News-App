import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/theme_provider.dart';

class ThemeToggleIcon extends StatelessWidget {
  const ThemeToggleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon:
          themeProvider.isDarkMode
              ? Icon(Icons.dark_mode)
              : Icon(Icons.light_mode),
    );
  }
}
