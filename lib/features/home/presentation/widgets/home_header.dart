// lib/features/home/presentation/widgets/home_header.dart
import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';

class HomeHeader extends StatelessWidget {
  final User user;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.user,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          const SizedBox(width: 12),
          // Nombre
          _buildUserInfo(),
          // Notificación
          IconButton(
            onPressed: onNotificationTap ?? () {},
            icon: const Icon(Icons.notifications_outlined),
            color: const Color(0xFF1A1A1A),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2196F3),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          user.userName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenidos al portal ARKOD',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Hola, ${user.firstName} ${user.lastName}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}