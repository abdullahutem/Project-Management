import 'package:cmp/models/projects_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProjectCardNoEdit extends StatefulWidget {
  final ProjectsModel projectModel;
  final VoidCallback onTap;

  const ProjectCardNoEdit({
    Key? key,
    required this.projectModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ProjectCardNoEdit> createState() => _ProjectCardNoEditState();
}

class _ProjectCardNoEditState extends State<ProjectCardNoEdit> {
  bool isExpanded = false;

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
    final Color statusColor = widget.projectModel.project.isActive
        ? const Color(0xff4CAF50)
        : const Color(0xffF44336);
    double hoursProgress =
        (widget.projectModel.currentHours / widget.projectModel.maxHours).clamp(
          0.0,
          1.0,
        );

    return InkWell(
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
            // ====== HEADER ======
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
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
                          widget.projectModel.project.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatusChip(
                              widget.projectModel.project.status,
                              _getStatusColor(
                                widget.projectModel.project.status,
                              ),
                            ),
                            const SizedBox(width: 4),
                            _buildStatusChip(
                              widget.projectModel.project.isActive
                                  ? 'نشط'
                                  : 'غير نشط',
                              statusColor,
                            ),
                            const SizedBox(width: 4),
                            _buildStatusChip(
                              "${widget.projectModel.usersCount} موظف",
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

            // ====== COLLAPSIBLE CONTENT ======
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildCollapsed(),
              secondChild: _buildExpanded(hoursProgress),
            ),

            // ====== TOGGLE BUTTON ======
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

  /// ===== COLLAPSED VIEW =====
  Widget _buildCollapsed() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: _buildSection(
        title: 'الساعات والتكاليف',
        children: [
          _buildDetailRow(
            label: 'الساعات المنجزة',
            value: widget.projectModel.currentHours.toStringAsFixed(2),
            assetName: "assets/svgs/current_hours.svg",
            color: Colors.black87,
          ),
          const SizedBox(width: 5),
          _buildDetailRow(
            label: 'إجمالي التكلفة',
            value: widget.projectModel.currentCost.toStringAsFixed(2),
            assetName: "assets/svgs/current_cost.svg",
            color: Colors.black87,
          ),
          const SizedBox(width: 5),
          _buildDetailRow(
            label: 'التكلفة الشهرية',
            value: widget.projectModel.currentMonthCost.toStringAsFixed(2),
            assetName: "assets/svgs/current_month_cost.svg",
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  /// ===== EXPANDED VIEW =====
  Widget _buildExpanded(double hoursProgress) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildSection(
            title: 'الساعات والتكاليف',
            children: [
              _buildDetailRow(
                label: 'الساعات المنجزة',
                value: widget.projectModel.currentHours.toStringAsFixed(2),
                assetName: "assets/svgs/current_hours.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'إجمالي التكلفة',
                value: widget.projectModel.currentCost.toStringAsFixed(2),
                assetName: "assets/svgs/current_cost.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'التكلفة الشهرية',
                value: widget.projectModel.currentMonthCost.toStringAsFixed(2),
                assetName: "assets/svgs/current_month_cost.svg",
                color: Colors.black87,
              ),
            ],
          ),
          _buildSection(
            title: 'التواريخ',
            children: [
              _buildDetailRow(
                label: 'تاريخ البدء',
                value: widget.projectModel.project.startDate,
                assetName: "assets/svgs/StartDate.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'تاريخ الانتهاء',
                value: widget.projectModel.project.endDate,
                assetName: "assets/svgs/EndDate.svg",
                color: Colors.black87,
              ),
            ],
          ),
          _buildSection(
            title: 'المهام',
            children: [
              _buildDetailRow(
                label: 'نشطة',
                value: widget.projectModel.taskActiveCounts.toString(),
                assetName: "assets/svgs/ActiveTasks.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'قيد الانتظار',
                value: widget.projectModel.taskPendingCounts.toString(),
                assetName: "assets/svgs/PendingTasks.svg",
                color: Colors.black87,
              ),
              const SizedBox(width: 5),
              _buildDetailRow(
                label: 'مكتملة',
                value: widget.projectModel.taskCompletedCounts.toString(),
                assetName: "assets/svgs/CompletedTasks.svg",
                color: Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildProgressIndicator(
            label: 'نسبة التقدم',
            value: widget.projectModel.completionPercentage / 100,
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
    );
  }

  // ===== Helpers =====

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
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
            Text(
              "${(value * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                fontSize: 15,
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
          minHeight: 10,
        ),
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
        padding: const EdgeInsets.all(12),
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
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            SvgPicture.asset(assetName, width: 35, height: 35),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
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

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
