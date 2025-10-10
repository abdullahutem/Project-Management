import 'package:flutter/material.dart';
import 'package:cmp/models/task_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class NewTaskCard extends StatelessWidget {
  final TaskModel taskModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback changeToActive;
  final VoidCallback changeToComplete;
  final VoidCallback changeToPending;
  final VoidCallback changeToTrue;
  final VoidCallback changeToFalse;

  const NewTaskCard({
    Key? key,
    required this.taskModel,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.changeToActive,
    required this.changeToComplete,
    required this.changeToPending,
    required this.changeToTrue,
    required this.changeToFalse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _getStatusColor(String status) {
      switch (status) {
        case 'Active':
          return Colors.blue;
        case 'Completed':
          return Colors.green;
        case 'Pending':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    final Color activeColor = taskModel.is_active ? Colors.green : Colors.red;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xff038187), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                const Divider(color: Colors.grey, height: 1),
                _buildSection(
                  title: 'حالة المهمة',
                  children: [
                    _buildDetailRow(
                      label: 'الحــالة',
                      value: taskModel.status,
                      icon: Icons.info_outline,
                      color: _getStatusColor(taskModel.status),
                    ),
                    const SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'نشط',
                      value: taskModel.is_active ? 'نشط' : 'غير نشط',
                      icon: Icons.check_circle_outline,
                      color: activeColor,
                    ),
                    const SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'عدد الردود',
                      value: taskModel.replies_count.toString(),
                      icon: Icons.comment_outlined,
                      color: Colors.black87,
                    ),
                  ],
                ),
                _buildSection(
                  title: 'التكاليف',
                  children: [
                    _buildDetailRow(
                      label: 'التكلفة الحالية',
                      value: taskModel.current_cost % 1 == 0
                          ? taskModel.current_cost.toInt().toString()
                          : taskModel.current_cost.toStringAsFixed(2),
                      icon: Icons.price_check,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 25),
                    _buildDetailRow(
                      label: 'معرف المشروع/الموظف',
                      value: taskModel.project_user_id.toString(),
                      icon: Icons.link,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.task_outlined, color: Color(0xff038187), size: 24),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            taskModel.task,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff038187),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Active') {
              changeToActive();
            } else if (value == 'Completed') {
              changeToComplete();
            } else if (value == 'Pending') {
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
            if (taskModel.status == "Active") ...[
              PopupMenuItem<String>(
                value: 'Completed',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مكتمل', style: TextStyle(color: Colors.black)),
                    Icon(Icons.check_circle_outline, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Pending',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('قيد الانتظار', style: TextStyle(color: Colors.black)),
                    Icon(Icons.hourglass_empty, color: Colors.orange),
                  ],
                ),
              ),
            ],
            if (taskModel.status == "Completed") ...[
              PopupMenuItem<String>(
                value: 'Active',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('نشيط', style: TextStyle(color: Colors.black)),
                    Icon(Icons.directions_run, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Pending',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('قيد الانتظار', style: TextStyle(color: Colors.black)),
                    Icon(Icons.hourglass_empty, color: Colors.orange),
                  ],
                ),
              ),
            ],
            if (taskModel.status == "Pending") ...[
              PopupMenuItem<String>(
                value: 'Active',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('نشيط', style: TextStyle(color: Colors.black)),
                    Icon(Icons.directions_run, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Completed',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مكتمل', style: TextStyle(color: Colors.black)),
                    Icon(Icons.check_circle_outline, color: Colors.blue),
                  ],
                ),
              ),
            ],
            if (taskModel.is_active == true) ...[
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
            if (taskModel.is_active == false) ...[
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
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey, height: 3),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: ColorManager.primaryColor,
              child: Icon(icon, color: Colors.white, size: 15),
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
