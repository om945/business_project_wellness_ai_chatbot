import 'package:flutter/material.dart';
import 'package:wellnest_chatbot/models/storage_service.dart';
import 'package:wellnest_chatbot/pages/onboarding_screen.dart';
import 'package:wellnest_chatbot/pages/setting.dart';
import 'package:wellnest_chatbot/theme/theme.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onDataCleared;
  const MyDrawer({super.key, this.onDataCleared});
  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 50),
        children: [
          ListTile(
            title: Text('Homepage'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
          ListTile(
            title: Text('About', softWrap: true),
            leading: Icon(Icons.info),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.redAccent),
            title: Text(
              'Reset My Data',
              style: TextStyle(
                fontFamily: googleFontNormal,
                color: Colors.redAccent,
              ),
            ),
            onTap: () async {
              // Show confirmation dialog
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Reset'),
                  content: Text(
                    'Are you sure you want to reset your profile data? This will restart the app.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Reset'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await storageService.clearUserData();
                // Navigate to onboarding screen and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
