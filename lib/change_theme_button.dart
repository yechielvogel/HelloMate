import 'package:flutter/material.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ChangeThemeButtonWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Switch.adaptive(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleTheme(value);
          },
        ),
        const SizedBox(height: 16),
        Switch.adaptive(
          value: themeProvider.isSystem,
          onChanged: (value) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleSystem(value);
          },
          activeColor: Colors.blue, // Customize the active color if desired
        ),
      ],
    );
  }
}
