class AppUser {
  final String uid;
  final String name;
  final String bio;
  final String gender;
  final String image;
  final bool isActive;

  AppUser({
    required this.uid,
    required this.name,
    required this.bio,
    required this.gender,
    required this.image,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'bio': bio,
      'gender': gender,
      'image': image,
      'isActive': isActive,
      'createdAt': DateTime.now(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      bio: map['bio'],
      gender: map['gender'],
      image: map['image'],
      isActive: map['isActive'],
    );
  }
}
