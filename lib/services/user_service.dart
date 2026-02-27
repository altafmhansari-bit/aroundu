import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String bio,
    required String gender,
  }) async {
    await _users.doc(uid).set({
      'name': name,
      'bio': bio,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> streamUser(String uid) {
    return _users.doc(uid).snapshots();
  }
}
