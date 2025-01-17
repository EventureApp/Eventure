import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventure/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.tertiary,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Theme.of(context).unselectedWidgetColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
