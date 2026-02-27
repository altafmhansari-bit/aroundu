import 'package:aroundu/features/chat/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/user_model.dart';
import '../widgets/nearby_user_card.dart';
import '../../../core/utils/geo_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Active Nearby")),
      body: currentUser == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No active users nearby"));
                }

                /// 🔹 current user document
                final currentUserDoc = snapshot.data!.docs.firstWhere(
                  (doc) => doc.id == currentUser.uid,
                  orElse: () => throw Exception("Current user data not found"),
                );

                final currentLat = currentUserDoc['latitude'];
                final currentLng = currentUserDoc['longitude'];

                /// 🔹 filter nearby users (≤ 5 km)
                final nearbyUsers = snapshot.data!.docs
                    .where((doc) => doc.id != currentUser.uid)
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      if (!data.containsKey('latitude') ||
                          !data.containsKey('longitude')) {
                        return null;
                      }

                      final distance = GeoUtils.distanceInKm(
                        currentLat,
                        currentLng,
                        data['latitude'],
                        data['longitude'],
                      );

                      if (distance <= 5) {
                        return AppUser.fromMap(data);
                      }
                      return null;
                    })
                    .whereType<AppUser>()
                    .toList();

                if (nearbyUsers.isEmpty) {
                  return const Center(
                    child: Text("No nearby users within 5 km"),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: nearbyUsers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: .78,
                  ),
                  itemBuilder: (context, index) {
                    return NearbyUserCard(
                      user: nearbyUsers[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                              otherUserId: nearbyUsers[index].uid,
                              otherUserName: nearbyUsers[index].name,
                            ),
                          ),
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
