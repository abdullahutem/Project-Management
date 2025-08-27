import 'package:flutter/material.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class NewUserCard extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const NewUserCard({
    Key? key,
    required this.userModel,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    int totalTasks =
        userModel.task_active_counts +
        userModel.task_pending_counts +
        userModel.task_completed_counts;

    double taskCompletionPercentage = totalTasks > 0
        ? userModel.task_completed_counts / totalTasks
        : 0.0;

    double efficiency = totalTasks > 0
        ? (userModel.task_completed_counts / totalTasks)
        : 0.0;

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                const Divider(color: Colors.grey, height: 1),
                _buildSection(
                  title: 'المعلومات الأساسية',
                  children: [
                    _buildDetailRow(
                      label: 'الدور',
                      value: userModel.role,
                      icon: Icons.work_outline,
                      color: _getRoleColor(userModel.role),
                    ),
                    const SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'الراتب الأساسي',
                      value: '${userModel.base_salary.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'عدد المشاريع',
                      value: userModel.projects_count.toString(),
                      icon: Icons.business_center,
                      color: Colors.black87,
                    ),
                  ],
                ),
                _buildSection(
                  title: 'معلومات الاتصال',
                  children: [
                    _buildDetailRow(
                      label: 'البريد الإلكتروني',
                      value: userModel.email,
                      icon: Icons.email_outlined,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'الهاتف',
                      value: userModel.phone,
                      icon: Icons.phone,
                      color: Colors.black87,
                    ),
                  ],
                ),
                _buildSection(
                  title: 'المهام',
                  children: [
                    _buildDetailRow(
                      label: 'المهام النشطة',
                      value: userModel.task_active_counts.toString(),
                      icon: Icons.check_box_outlined,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'المهام قيد الانتظار',
                      value: userModel.task_pending_counts.toString(),
                      icon: Icons.watch_later_outlined,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'المهام المكتملة',
                      value: userModel.task_completed_counts.toString(),
                      icon: Icons.task_alt,
                      color: Colors.black87,
                    ),
                  ],
                ),
                _buildSection(
                  title: 'الإنتاجية',
                  children: [
                    _buildDetailRow(
                      label: 'إجمالي الساعات',
                      value: userModel.total_hours.toStringAsFixed(2),
                      icon: Icons.access_time,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'إجمالي التكلفة',
                      value: userModel.total_cost.toStringAsFixed(2),
                      icon: Icons.price_check,
                      color: Colors.black87,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProgressIndicator(
                  label: 'إنجاز المهام',
                  value: taskCompletionPercentage,
                  color: const Color(0xff038187),
                ),
                const SizedBox(height: 8),
                _buildProgressIndicator(
                  label: 'الكفاءة',
                  value: efficiency,
                  color: Colors.purple,
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
        const Icon(Icons.person_outline, color: Color(0xff038187), size: 24),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            userModel.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff038187),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('تعديل', style: TextStyle(color: Colors.black)),
                  Icon(Icons.edit_outlined, color: Colors.blue),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('حذف', style: TextStyle(color: Colors.black)),
                  Icon(Icons.delete_outline, color: Colors.red),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
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

  Widget _buildProgressIndicator({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          color: color,
          borderRadius: BorderRadius.circular(10),
          minHeight: 10,
        ),
      ],
    );
  }
}
