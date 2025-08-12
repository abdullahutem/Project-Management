import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

class BeautifulAssignedUserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const BeautifulAssignedUserCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.blue;
      case 'employee':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorManager.primaryColor.withOpacity(0.8),
                radius: 20,
                child: Text(
                  user.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: "EXPOARABIC",
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "EXPOARABIC",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        user.role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "EXPOARABIC",
                        ),
                      ),
                      backgroundColor: _getRoleColor(user.role),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
              // You can add more user details or actions here if needed
              // e.g., Icon(Icons.phone)
            ],
          ),
        ),
      ),
    );
  }
}
