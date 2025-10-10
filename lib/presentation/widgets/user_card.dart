import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class UserCard extends StatefulWidget {
  final UserModel userModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserCard({
    Key? key,
    required this.userModel,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isExpanded = false;

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
    final userModel = widget.userModel;

    int totalTasks =
        userModel.task_active_counts +
        userModel.task_pending_counts +
        userModel.task_completed_counts;

    double taskCompletionPercentage = totalTasks > 0
        ? userModel.task_completed_counts / totalTasks
        : 0.0;
    double efficiency = totalTasks > 0
        ? userModel.task_completed_counts / totalTasks
        : 0.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Gradient Header
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
                      "assets/svgs/EmployeesCounts.svg",
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
                          userModel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        _buildStatusChip(
                          userModel.role,
                          _getRoleColor(userModel.role),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'edit') widget.onEdit();
                      if (value == 'delete') widget.onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'تعديل',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(Icons.edit_outlined, color: Colors.blue),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('حذف', style: TextStyle(color: Colors.black)),
                            Icon(Icons.delete_outline, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==== MAIN CONTENT (Expandable) ====
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildCollapsed(userModel),
              secondChild: _buildExpanded(
                userModel,
                taskCompletionPercentage,
                efficiency,
              ),
            ),

            // ==== EXPAND / COLLAPSE BUTTON ====
            TextButton.icon(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: ColorManager.primaryColor,
              ),
              label: Text(
                isExpanded ? "إخفاء التفاصيل" : "عرض المزيد",
                style: TextStyle(color: ColorManager.primaryColor),
              ),
            ),
          ],
        ),
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

  /// Collapsed: Header + المعلومات الأساسية
  Widget _buildCollapsed(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: _buildSection(
        title: 'المعلومات الأساسية',
        children: [
          _buildDetailRow(
            label: 'الدور',
            value: user.role,
            assetName: "assets/svgs/Status.svg",
            color: _getRoleColor(user.role),
          ),
          const SizedBox(width: 5),
          _buildDetailRow(
            label: 'الراتب الأساسي',
            value: user.base_salary.toString(),
            assetName: "assets/svgs/max_cost.svg",
            color: Colors.black87,
          ),
          const SizedBox(width: 5),
          _buildDetailRow(
            label: 'عدد المشاريع',
            value: user.projects_count.toString(),
            assetName: "assets/svgs/ProjectName.svg",
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  /// Expanded: all sections
  Widget _buildExpanded(UserModel user, double completion, double efficiency) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildSection(
            title: 'المعلومات الأساسية',
            children: [
              _buildDetailRow(
                label: 'الدور',
                value: user.role,
                assetName: "assets/svgs/Status.svg",
                color: _getRoleColor(user.role),
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'الراتب الأساسي',
                value: user.base_salary.toString(),
                assetName: "assets/svgs/max_cost.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'عدد المشاريع',
                value: user.projects_count.toString(),
                assetName: "assets/svgs/ProjectName.svg",
                color: Colors.black87,
              ),
            ],
          ),
          _buildSection(
            title: 'معلومات الاتصال',
            children: [
              _buildDetailRow2(
                label: 'البريد الإلكتروني',
                value: user.email,
                assetName: "assets/svgs/email.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 10),
              _buildDetailRow2(
                label: 'الهاتف',
                value: user.phone,
                assetName: "assets/svgs/phone.svg",
                color: Colors.black87,
              ),
            ],
          ),
          _buildSection(
            title: 'المهام',
            children: [
              _buildDetailRow(
                label: 'نشطة',
                value: user.task_active_counts.toString(),
                assetName: "assets/svgs/ActiveTasks.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'قيد الانتظار',
                value: user.task_pending_counts.toString(),
                assetName: "assets/svgs/PendingTasks.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'مكتملة',
                value: user.task_completed_counts.toString(),
                assetName: "assets/svgs/CompletedTasks.svg",
                color: Colors.black87,
              ),
            ],
          ),
          _buildSection(
            title: 'الإنتاجية',
            children: [
              _buildDetailRow(
                label: 'الساعات',
                value: user.total_hours.toString(),
                assetName: "assets/svgs/current_hours.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'التكلفة',
                value: user.total_cost.toString(),
                assetName: "assets/svgs/current_cost.svg",
                color: Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildProgressIndicator(
            label: 'إنجاز المهام',
            value: completion,
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
    );
  }

  Widget _buildDetailRow2({
    required String label,
    required String value,
    required String assetName,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: ColorManager.primaryColor,
              radius: 20,
              child: SvgPicture.asset(assetName, width: 30, height: 30),
            ),
            const SizedBox(height: 7),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xff038187),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
        const Divider(height: 20, color: Colors.grey),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required String assetName,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
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
            SvgPicture.asset(assetName, width: 35, height: 35),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          color: color,
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }
}
