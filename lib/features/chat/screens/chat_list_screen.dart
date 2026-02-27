import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/chat_service.dart';
import '../../chat/screens/chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final ChatService _chatService = ChatService();
  final String myId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getChatList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;
              final List users = data['users'];
              final otherUserId = users.firstWhere((id) => id != myId);

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .snapshots(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final userData =
                      userSnap.data!.data() as Map<String, dynamic>;

                  // 🔹 Online / Last seen text
                  String statusText = "Offline";
                  if (userData['isActive'] == true) {
                    statusText = "Online";
                  } else if (userData['lastSeen'] != null) {
                    final lastSeen = DateTime.fromMillisecondsSinceEpoch(
                      userData['lastSeen'],
                    );
                    final mins = DateTime.now().difference(lastSeen).inMinutes;
                    statusText = "Last seen $mins min ago";
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userData['image'] != ''
                          ? NetworkImage(userData['image'])
                          : null,
                      child: userData['image'] == ''
                          ? Text(userData['name'][0])
                          : null,
                    ),

                    title: Text(
                      userData['name'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['lastMessage'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomScreen(
                            otherUserId: otherUserId,
                            otherUserName: userData['name'],
                          ),
                        ),
                      );
                    },

                    // 🔥 DELETE CHAT (LONG PRESS)
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Chat"),
                          content: const Text(
                            "This chat will be permanently deleted.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _chatService.deleteChat(otherUserId);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
