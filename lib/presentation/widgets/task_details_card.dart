import 'package:cmp/models/single_task_model.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class TaskDetailsCard extends StatelessWidget {
  final SingleTaskModel singleTask;

  const TaskDetailsCard({Key? key, required this.singleTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeColor = singleTask.task.is_active
        ? Colors.green
        : Colors.red;

    return Directionality(
      textDirection: TextDirection.rtl,
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
              // _buildSection(
              //   title: 'البيانات الأساسية',
              //   children: [
              //     _buildDetailRow(
              //       label: 'المشروع',
              //       value: singleTask.project_name,
              //       icon: Icons.info_outline,
              //       color: Colors.black87,
              //     ),
              //     const SizedBox(width: 5),
              //     _buildDetailRow(
              //       label: 'الموظف',
              //       value: singleTask.user_name,
              //       icon: Icons.comment_outlined,
              //       color: Colors.black87,
              //     ),
              //   ],
              // ),
              _buildSection(
                title: 'حالة المهمة',
                children: [
                  // _buildDetailRow(
                  //   label: 'الحــالة',
                  //   value: singleTask.task.status,
                  //   icon: Icons.info_outline,
                  //   color: _getStatusColor(singleTask.task.status),
                  // ),
                  const SizedBox(width: 5),
                  _buildDetailRow(
                    label: 'نشط',
                    value: singleTask.task.is_active ? 'نشط' : 'غير نشط',
                    icon: Icons.check_circle_outline,
                    color: activeColor,
                  ),
                  const SizedBox(width: 5),
                  _buildDetailRow(
                    label: 'عدد الردود',
                    value: singleTask.task.replies_count.toString(),
                    icon: Icons.comment_outlined,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 5),
                  _buildDetailRow(
                    label: 'التكلفة الحالية',
                    value: singleTask.task.current_cost.toStringAsFixed(2),
                    icon: Icons.info_outline,
                    color: Colors.black87,
                  ),
                ],
              ),
              // _buildSection(
              //   title: 'التكاليف',
              //   children: [
              //     _buildDetailRow(
              //       label: 'التكلفة الحالية',
              //       value: singleTask.task.current_cost.toStringAsFixed(2),
              //       icon: Icons.info_outline,
              //       color: Colors.black87,
              //     ),
              //   ],
              // ),
              //               _buildRow(
              //                 "التكلفة",
              //                 "${singleTask.task.current_cost.toStringAsFixed(2)}",
              //                 Icons.price_check,
              //                 Colors.brown,
              //               ),
              //               _buildRow(
              //                 "عدد الردود",
              //                 singleTask.task.replies_count.toString(),
              //                 Icons.comment_outlined,
              //                 Colors.deepPurple,
              //               ),
            ],
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
            singleTask.task.task,
            style: const TextStyle(
              fontSize: 18,
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
                fontSize: 16,
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
                fontSize: 12,
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
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
