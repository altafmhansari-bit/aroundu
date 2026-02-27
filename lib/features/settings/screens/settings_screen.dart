import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account section
          const Text("Account", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.block),
            title: const Text("Blocked Users"),
            onTap: () {
              // later → blocked users screen
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // later → Firebase logout
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Logged out")));
            },
          ),

          const Divider(height: 30),

          // App section
          const Text("App", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: false,
            onChanged: (value) {
              // later → theme toggle logic
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("App Version"),
            trailing: const Text("v1.0.0"),
          ),
        ],
      ),
    );
  }
}
