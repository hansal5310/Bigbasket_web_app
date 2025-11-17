import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';
import 'order_receipts_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: settings.notificationsEnabled,
            onChanged: (v) => settings.setNotificationsEnabled(v),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('Language'),
            onTap: () {},
          ),
          SwitchListTile(
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (v) =>
                settings.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('My Order Receipts'),
            subtitle: Text('View and download order receipts'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderReceiptsScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy & Terms'),
            onTap: () => _showPrivacy(context),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      clipBehavior: Clip.antiAlias,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Privacy Policy',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    'We value your privacy. We collect only necessary data to deliver our services, such as account and order details. We do not sell your data.'),
                SizedBox(height: 16),
                Text('Terms of Service',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    'By using this app you agree to use it lawfully, keep your account secure, and accept that services may change. See our website for full terms.'),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
