import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  String _gender = 'male';

  final _userService = UserService();
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userService.streamUser(_uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Initialize controllers once
          if (!_initialized) {
            _nameController.text = data['name'] ?? '';
            _bioController.text = data['bio'] ?? '';
            _gender = data['gender'] ?? 'male';
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar placeholder (image upload later)
                const CircleAvatar(
                  radius: 48,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 24),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bio
                TextField(
                  controller: _bioController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Gender
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Male"),
                      selected: _gender == 'male',
                      selectedColor: Colors.blue,
                      onSelected: (_) {
                        setState(() => _gender = 'male');
                      },
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text("Female"),
                      selected: _gender == 'female',
                      selectedColor: Colors.pink,
                      onSelected: (_) {
                        setState(() => _gender = 'female');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _userService.updateProfile(
                        uid: _uid,
                        name: _nameController.text.trim(),
                        bio: _bioController.text.trim(),
                        gender: _gender,
                      );

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile updated successfully"),
                          ),
                        );
                      }
                    },
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
