import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// SAME chatId for both users
  String getChatId(String otherUserId) {
    final myId = _auth.currentUser!.uid;
    final ids = [myId, otherUserId]..sort();
    return ids.join('_');
  }

  /// Messages stream
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Chat list stream
  Stream<QuerySnapshot> getChatList() {
    final myId = _auth.currentUser!.uid;
    return _firestore
        .collection('chats')
        .where('users', arrayContains: myId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  /// Send message
  Future<void> sendMessage(String otherUserId, String text) async {
    final myId = _auth.currentUser!.uid;
    final chatId = getChatId(otherUserId);
    final now = DateTime.now().millisecondsSinceEpoch;

    await _firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'users': [myId, otherUserId],
      'lastMessage': text,
      'updatedAt': now,
    }, SetOptions(merge: true));

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {'senderId': myId, 'text': text, 'timestamp': now},
    );
  }

  /// 🔥 DELETE CHAT (THIS WAS MISSING)
  Future<void> deleteChat(String otherUserId) async {
    final chatId = getChatId(otherUserId);

    // delete messages
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    // delete chat document
    await _firestore.collection('chats').doc(chatId).delete();
  }
}
