import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cmp/models/projects_model.dart';

class ProjectGeneralInfoCard extends StatelessWidget {
  final ProjectsModel projectModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback changeToActive;
  final VoidCallback changeToComplete;
  final VoidCallback changeToPending;
  final VoidCallback changeToTrue;
  final VoidCallback changeToFalse;

  const ProjectGeneralInfoCard({
    Key? key,
    required this.projectModel,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.changeToActive,
    required this.changeToComplete,
    required this.changeToPending,
    required this.changeToTrue,
    required this.changeToFalse,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xff4CAF50);
      case 'Completed':
        return const Color(0xff2196F3);
      case 'Pending':
        return const Color(0xffFF9800);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = projectModel.project.isActive
        ? const Color(0xff4CAF50)
        : const Color(0xffF44336);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          projectModel.project.name,
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
                              projectModel.project.status,
                              _getStatusColor(projectModel.project.status),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(
                              projectModel.project.isActive ? 'نشط' : 'غير نشط',
                              statusColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'Active') {
                        changeToActive();
                      } else if (value == 'Completed') {
                        changeToComplete();
                      } else if (value == 'Pending') {
                        changeToPending();
                      } else if (value == 'true') {
                        changeToTrue();
                      } else if (value == 'false') {
                        changeToFalse();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      if (projectModel.project.status == "Active") ...[
                        PopupMenuItem<String>(
                          value: 'Completed',
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
                          value: 'Pending',
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
                      if (projectModel.project.status == "Completed") ...[
                        PopupMenuItem<String>(
                          value: 'Active',
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
                          value: 'Pending',
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
                      if (projectModel.project.status == "Pending") ...[
                        PopupMenuItem<String>(
                          value: 'Active',
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
                          value: 'Completed',
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
                      if (projectModel.project.isActive == true) ...[
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
                      if (projectModel.project.isActive == false) ...[
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
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard(
                          icon: "assets/svgs/EmployeesCounts.svg",
                          label: 'عدد الموظفين',
                          date: projectModel.usersCount.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateCard(
                          icon: "assets/svgs/StartDate.svg",
                          label: 'تاريخ البدء',
                          date: projectModel.project.startDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateCard(
                          icon: "assets/svgs/EndDate.svg",
                          label: 'تاريخ الانتهاء',
                          date: projectModel.project.endDate,
                        ),
                      ),
                    ],
                  ),
                ],
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

  Widget _buildDateCard({
    required String icon,
    required String label,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SvgPicture.asset(icon, width: 40, height: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
