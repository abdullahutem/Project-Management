import 'package:cmp/models/task_model.dart';
import 'package:flutter/material.dart';

class BeautifulTaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback changeToActive;
  final VoidCallback changeToComplete;
  final VoidCallback changeToPending;
  final VoidCallback changeToTrue;
  final VoidCallback changeToFalse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const BeautifulTaskCard({
    super.key,
    required this.task,
    required this.changeToActive,
    required this.changeToComplete,
    required this.changeToPending,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.changeToTrue,
    required this.changeToFalse,
  });

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

  Color _getIsActiveColor(String active) {
    switch (active.toLowerCase()) {
      case 'true':
        return Colors.green;
      case 'false':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'قيد التنفيذ':
        return Icons.play_circle_fill;
      case 'مكتمل':
        return Icons.check_circle;
      case 'معلق':
        return Icons.pause_circle_filled;
      case 'ملغى':
        return Icons.cancel;
      default:
        return Icons.info;
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
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: Icon(
            _getStatusIcon(task.status),
            color: _getStatusColor(task.status),
            size: 30,
          ),
          title: Text(
            task.task,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'الحالة: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    task.status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(task.status),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'التفعيل: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    task.is_active.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _getIsActiveColor(task.is_active.toString()),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'active') {
                changeToActive();
              } else if (value == 'completed') {
                changeToComplete();
              } else if (value == 'pending') {
                changeToPending();
              } else if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              } else if (value == 'true') {
                changeToTrue();
              } else if (value == 'false') {
                changeToFalse();
              }
            },
            itemBuilder: (BuildContext context) => [
              if (task.status == "active") ...[
                PopupMenuItem<String>(
                  value: 'completed',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('مكتمل', style: TextStyle(color: Colors.black)),
                      Icon(Icons.check_circle_outline, color: Colors.blue),
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
              if (task.status == "completed") ...[
                PopupMenuItem<String>(
                  value: 'active',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('نشيط', style: TextStyle(color: Colors.black)),
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
              if (task.status == "pending") ...[
                PopupMenuItem<String>(
                  value: 'active',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('نشيط', style: TextStyle(color: Colors.black)),
                      Icon(Icons.directions_run, color: Colors.green),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'completed',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('مكتمل', style: TextStyle(color: Colors.black)),
                      Icon(Icons.check_circle_outline, color: Colors.blue),
                    ],
                  ),
                ),
              ],
              if (task.is_active == true) ...[
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
              if (task.is_active == false) ...[
                PopupMenuItem<String>(
                  value: 'true',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('تفعيل', style: TextStyle(color: Colors.black)),
                      Icon(Icons.check_circle_outline, color: Colors.green),
                    ],
                  ),
                ),
              ],

              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('تعديل', style: TextStyle(color: Colors.black)),
                    Icon(Icons.edit, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('حذف', style: TextStyle(color: Colors.black)),
                    Icon(Icons.delete, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
