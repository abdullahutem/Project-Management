import 'package:flutter/material.dart';
import 'package:cmp/models/task_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class EmployeeNewTaskCard extends StatelessWidget {
  final TaskModel taskModel;
  final VoidCallback onTap;

  const EmployeeNewTaskCard({
    Key? key,
    required this.taskModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Icon(icon, color: Colors.white, size: 20),
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
