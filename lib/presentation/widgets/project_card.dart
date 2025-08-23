import 'package:cmp/models/project_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback changeToActive;
  final VoidCallback changeToComplete;
  final VoidCallback changeToPending;
  final VoidCallback changeToTrue;
  final VoidCallback changeToFalse;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.changeToActive,
    required this.changeToComplete,
    required this.changeToPending,
    required this.changeToTrue,
    required this.changeToFalse,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color for the status indicator
    final Color statusColor = project.isActive ? Colors.green : Colors.red;

    // Calculate the progress percentage based on dates
    final now = DateTime.now();
    final startDate = DateTime.parse(project.startDate);
    final endDate = DateTime.parse(project.endDate);

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = now.difference(startDate).inDays;
    double progress = totalDuration > 0 ? elapsedDuration / totalDuration : 0.0;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    Color _getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'active':
          return Colors.blue;
        case 'completed':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        project.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: statusColor,
                          // fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'active') {
                        changeToActive();
                      } else if (value == 'completed') {
                        changeToComplete();
                      } else if (value == 'pending') {
                        changeToPending();
                      } else if (value == 'true') {
                        changeToTrue();
                      } else if (value == 'false') {
                        changeToFalse();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      if (project.status == "active") ...[
                        PopupMenuItem<String>(
                          value: 'completed',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'مكتمل',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'pending',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'قيد الانتظار',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.hourglass_empty, color: Colors.orange),
                            ],
                          ),
                        ),
                      ],
                      if (project.status == "completed") ...[
                        PopupMenuItem<String>(
                          value: 'active',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'نشيط',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.directions_run, color: Colors.green),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'pending',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'قيد الانتظار',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.hourglass_empty, color: Colors.orange),
                            ],
                          ),
                        ),
                      ],
                      if (project.status == "pending") ...[
                        PopupMenuItem<String>(
                          value: 'active',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'نشيط',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.directions_run, color: Colors.green),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'completed',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'مكتمل',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'تعديل',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Icon(Icons.edit_outlined, color: Colors.blue),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'حذف',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Icon(Icons.delete_outline, color: Colors.red),
                          ],
                        ),
                      ),
                      if (project.isActive == true) ...[
                        PopupMenuItem<String>(
                          value: 'false',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'إلغاء التفعيل',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(Icons.stop_circle, color: Colors.red),
                            ],
                          ),
                        ),
                      ],
                      if (project.isActive == false) ...[
                        PopupMenuItem<String>(
                          value: 'true',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'تفعيل',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                project.name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "الحالة:  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    project.status,
                    style: TextStyle(
                      color: _getStatusColor(project.status),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    intl.DateFormat('dd/MM/yyyy').format(endDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
