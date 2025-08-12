import 'package:cmp/models/projects_of_user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ProjectCardForUser extends StatelessWidget {
  final ProjectsModel project;
  final VoidCallback onTap;

  const ProjectCardForUser({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color for the status indicator
    // final Color statusColor = project.isActive ? Colors.green : Colors.red;

    // Calculate the progress percentage based on dates
    final now = DateTime.now();
    final startDate = DateTime.parse(project.startDate);
    final endDate = DateTime.parse(project.endDate);

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = now.difference(startDate).inDays;
    double progress = totalDuration > 0 ? elapsedDuration / totalDuration : 0.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "EXPOARABIC",
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'الحالة: ${project.status}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: "EXPOARABIC",
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: ColorManager.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    intl.DateFormat('dd/MM/yyyy').format(startDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "EXPOARABIC",
                    ),
                  ),
                  Text(
                    intl.DateFormat('dd/MM/yyyy').format(endDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "EXPOARABIC",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
