import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/auth_service.dart';
//import '../../../services/user_service.dart';
//import '../../../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(height: 30),

            isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
                    text: "Create Account",
                    onTap: () async {
                      try {
                        final auth = AuthService();

                        final user = await auth.signUp(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        if (user == null) {
                          throw "Auth user is null";
                        }

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set({
                              'uid': user.uid,
                              'name': nameController.text.trim(),
                              'bio': 'Hey! I’m new here 👋',
                              'gender': 'male',
                              'image': '',
                              'isActive': true,
                              'latitude': 0.0,
                              'longitude': 0.0,
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("User saved to Firestore"),
                          ),
                        );

                        Navigator.pop(context); // back to login
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("ERROR: $e")));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
