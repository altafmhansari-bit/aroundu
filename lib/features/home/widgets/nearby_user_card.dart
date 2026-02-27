import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../core/constants/app_colors.dart';

class NearbyUserCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;

  const NearbyUserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMale = user.gender.toLowerCase() == 'male';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 32, backgroundImage: NetworkImage(user.image)),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              user.bio,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Icon(
              Icons.circle,
              size: 10,
              color: isMale ? Colors.blue : Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
