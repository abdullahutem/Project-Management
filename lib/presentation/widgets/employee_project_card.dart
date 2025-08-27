import 'package:flutter/material.dart';
import 'package:cmp/models/projects_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeProjectCard extends StatelessWidget {
  final ProjectsModel projectModel;
  final VoidCallback onTap;

  const EmployeeProjectCard({
    Key? key,
    required this.projectModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color statusColor = projectModel.project.isActive
        ? Colors.green
        : Colors.red;

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

    double hoursProgress = (projectModel.currentHours / projectModel.maxHours)
        .clamp(0.0, 1.0);

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
                  title: 'تفاصيل المشروع',
                  children: [
                    _buildDetailRow(
                      label: 'الحــالة',
                      value: projectModel.project.status,
                      color: _getStatusColor(projectModel.project.status),
                      assetName: "assets/svgs/ActiveTasks.svg",
                    ),
                    SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'نشط',
                      value: projectModel.project.isActive ? 'نشط' : 'غير نشط',
                      color: statusColor,
                      assetName: "assets/svgs/IsActive.svg",
                    ),
                    SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'عدد الموظفين',
                      value: projectModel.usersCount.toString(),
                      color: Colors.black87,
                      assetName: "assets/svgs/EmployeesCounts.svg",
                    ),
                  ],
                ),
                _buildSection(
                  title: 'التواريخ',
                  children: [
                    _buildDetailRow(
                      label: 'تاريخ البدء',
                      value: projectModel.project.startDate,
                      color: Colors.black87,
                      assetName: "assets/svgs/StartDate.svg",
                    ),
                    SizedBox(width: 25),
                    _buildDetailRow(
                      label: 'تاريخ الانتهاء',
                      value: projectModel.project.endDate,
                      color: Colors.black87,
                      assetName: "assets/svgs/EndDate.svg",
                    ),
                  ],
                ),
                _buildSection(
                  title: 'المهام',
                  children: [
                    _buildDetailRow(
                      label: 'المهام المفعلة',
                      value: projectModel.taskActiveCounts.toString(),
                      color: Colors.black87,
                      assetName: "assets/svgs/ActiveTasks.svg",
                    ),
                    SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'المهام قيد الانتظار',
                      value: projectModel.taskPendingCounts.toString(),
                      color: Colors.black87,
                      assetName: "assets/svgs/PendingTasks.svg",
                    ),
                    SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'المهام المكتملة',
                      value: projectModel.taskCompletedCounts.toString(),
                      color: Colors.black87,
                      assetName: "assets/svgs/CompletedTasks.svg",
                    ),
                  ],
                ),
                _buildSection(
                  title: 'الساعات والتكاليف',
                  children: [
                    _buildDetailRow(
                      label: 'الساعات المنجزة',
                      value:
                          '${projectModel.currentHours.toStringAsFixed(2)} من ${projectModel.maxHours.toStringAsFixed(2)}',
                      color: Colors.black87,
                      assetName: "assets/svgs/current_hours.svg",
                    ),
                    SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'التكلفة الحالية',
                      value: projectModel.currentCost.toStringAsFixed(2),
                      color: Colors.black87,
                      assetName: "assets/svgs/current_cost.svg",
                    ),
                    SizedBox(width: 2),
                    _buildDetailRow(
                      label: 'التكلفة الشهرية',
                      value: projectModel.currentMonthCost.toStringAsFixed(2),
                      color: Colors.black87,
                      assetName: "assets/svgs/current_month_cost.svg",
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildDetailRow(
                      label: 'نطاق الساعات',
                      value:
                          '${projectModel.minHours} - ${projectModel.maxHours}',
                      assetName: "assets/svgs/MaxHours.svg",
                      color: Colors.black87,
                    ),
                    SizedBox(width: 5),
                    _buildDetailRow(
                      label: 'نطاق التكلفة',
                      value:
                          '${projectModel.minCost.toStringAsFixed(2)} - ${projectModel.maxCost.toStringAsFixed(2)}',
                      assetName: "assets/svgs/min_cost.svg",
                      color: Colors.black87,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProgressIndicator(
                  label: 'نسبة التقدم',
                  value: projectModel.completionPercentage / 100,
                  color: const Color(0xff038187),
                ),
                const SizedBox(height: 8),
                _buildProgressIndicator(
                  label: 'نسبة الساعات المنجزة',
                  value: hoursProgress,
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
        SvgPicture.asset("assets/svgs/ProjectName.svg", height: 60, width: 60),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            projectModel.project.name,
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
    required String assetName,
    // required IconData icon,
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
            SvgPicture.asset(assetName, width: 40, height: 40),
            // Image.asset(assetName, height: 40, width: 40),

            // CircleAvatar(
            //   backgroundColor: ColorManager.primaryColor,
            //   child: Icon(icon, color: Colors.white, size: 20),
            // ),
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
