import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'location_service.dart';

class PresenceService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _locationService = LocationService();

  Future<void> setUserActive(bool isActive) async {
    final user = _auth.currentUser;
    if (user == null) return;

    double? lat;
    double? long;

    try {
      final position = await _locationService.getCurrentLocation();
      lat = position.latitude;
      long = position.longitude;
    } catch (_) {}

    await _firestore.collection('users').doc(user.uid).update({
      'isActive': isActive,
      if (lat != null) 'latitude': lat,
      if (long != null) 'longitude': long,
    });
  }
}
