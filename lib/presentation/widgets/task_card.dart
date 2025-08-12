import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String task;
  final String status;
  final bool isActive;
  // final String projectName;
  // final String userName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.status,
    required this.isActive,
    // required this.projectName,
    // required this.userName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text("الحالة: $status"),
            SizedBox(height: 5),
            Text("نشط: ${isActive ? 'نعم' : 'لا'}"),
            // SizedBox(height: 5),
            // Text("المشروع: $projectName"),
            // SizedBox(height: 5),
            // Text("المستخدم: $userName"),
          ],
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
