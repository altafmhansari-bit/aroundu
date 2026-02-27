import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  String name = "Your Name";
  String bio = "Your bio goes here";
  String gender = "male";

  void updateProfile(String newName, String newBio, String newGender) {
    name = newName;
    bio = newBio;
    gender = newGender;
    notifyListeners();
  }
}
