import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Kigali App User'),
            accountEmail: Text(authProvider.user?.email ?? 'Not Signed In'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 48, color: Colors.blue),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('App Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          SwitchListTile(
            title: const Text('Enable Location Notifications'),
            subtitle: const Text('Get alerts when you are near a saved service point'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
            secondary: const Icon(Icons.notifications_active),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('Email'),
            subtitle: Text(authProvider.user?.email ?? 'N/A'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
                  ],
                ),
              );
              if (confirm == true) {
                await authProvider.logout();
              }
            },
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info),
            applicationName: 'Kigali City Services',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2026 Kigali Directory',
            child: Text('About This App'),
          ),
        ],
      ),
    );
  }
}
