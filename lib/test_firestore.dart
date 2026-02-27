import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest extends StatelessWidget {
  const FirestoreTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Test")),
      body: Center(
        child: ElevatedButton(
          child: const Text("WRITE TO FIRESTORE"),
          onPressed: () async {
            try {
              await FirebaseFirestore.instance.collection('test').add({
                'time': DateTime.now().toString(),
              });

              print("✅ Firestore write success");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Write Success")));
            } catch (e) {
              print("❌ Firestore error: $e");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: $e")));
            }
          },
        ),
      ),
    );
  }
}
