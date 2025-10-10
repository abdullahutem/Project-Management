import 'package:cmp/models/single_task_model.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_svg/svg.dart';

class TaskDetailsCard extends StatelessWidget {
  final SingleTaskModel singleTask;

  const TaskDetailsCard({Key? key, required this.singleTask}) : super(key: key);

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

    final Color activeColor = singleTask.task.is_active
        ? Colors.green
        : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    "assets/svgs/ProjectName.svg",
                    height: 40,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        singleTask.task.task,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(
                            singleTask.task.status,
                            _getStatusColor(singleTask.task.status),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            singleTask.task.is_active ? 'نشط' : 'غير نشط',
                            activeColor,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            singleTask.task.replies_count == 1
                                ? "${singleTask.task.replies_count} رد"
                                : singleTask.task.replies_count > 1
                                ? "${singleTask.task.replies_count} ردود"
                                : "بدون ردود",
                            ColorManager.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey, height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSection(
              title: 'حالة المهمة',
              children: [
                _buildDetailRow(
                  label: 'التكلفة الشهرية',
                  value: "غير مدرجة",
                  icon: Icons.money_outlined,
                  color: Colors.black87,
                ),
                const SizedBox(width: 8),
                _buildDetailRow(
                  label: 'إجمالي التكلفة',
                  value: singleTask.task.current_cost % 1 == 0
                      ? singleTask.task.current_cost.toInt().toString()
                      : singleTask.task.current_cost.toStringAsFixed(2),
                  icon: Icons.price_check,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff038187),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: children),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey, height: 2),
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
