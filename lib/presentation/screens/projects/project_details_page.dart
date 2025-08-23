import 'package:cmp/models/single_project_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/users/user_details_page.dart';
import 'package:cmp/presentation/widgets/beautiful_assigned_user_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ProjectDetailsPage extends StatelessWidget {
  final SingleProjectModel project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = DateTime.parse(project.projectModel.startDate);
    final endDate = DateTime.parse(project.projectModel.endDate);

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = now.difference(startDate).inDays;
    double progress = totalDuration > 0 ? elapsedDuration / totalDuration : 0.0;
    if (progress > 1.0) progress = 1.0; // Cap at 100%
    if (progress < 0.0) progress = 0.0; // Cap at 0%
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pushNamed(context, Routes.addProjectUserPage);
        },
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'أضف موظف للمشروع',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorManager.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          project.projectModel.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Overview Card
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل المشروع',
                      style: const TextStyle(
                        color: ColorManager.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),
                    _buildDetailRow(
                      Icons.tab_sharp,
                      'إسم المشروع:',
                      project.projectModel.name,
                    ),
                    _buildDetailRow(
                      Icons.check_circle_outline,
                      'الحالة:',
                      project.projectModel.status,
                      project.projectModel.isActive ? Colors.green : Colors.red,
                    ),
                    _buildDetailRow(
                      Icons.check_circle_outline,
                      'مفعل:',
                      project.projectModel.isActive.toString(),
                      project.projectModel.isActive ? Colors.green : Colors.red,
                    ),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'تاريخ البدء:',
                      intl.DateFormat('dd/MM/yyyy').format(startDate),
                    ),
                    _buildDetailRow(
                      Icons.event,
                      'تاريخ الانتهاء:',
                      intl.DateFormat('dd/MM/yyyy').format(endDate),
                    ),

                    _buildDetailRow(
                      Icons.person_outline,
                      'عدد الموظفين',
                      project.usersCount.toString(),
                    ),
                    _buildDetailRow(
                      Icons.check_box_outlined,
                      'عدد المهام المفعلة',
                      project.taskActiveCounts.toString(),
                    ),
                    _buildDetailRow(
                      Icons.watch_later_outlined,
                      'عدد المهام قيد الإنتظار',
                      project.taskPendingCounts.toString(),
                    ),

                    _buildDetailRow(
                      Icons.task_alt,
                      'عدد المهام المكتملة',
                      project.taskCompletedCounts.toString(),
                    ),
                    _buildDetailRow(
                      Icons.hourglass_bottom,
                      'عدد الساعات الأدنى',
                      project.minHours.toString(),
                    ),
                    _buildDetailRow(
                      Icons.hourglass_top,
                      'عدد الساعات الأقصى',
                      project.maxHours.toString(),
                    ),
                    _buildDetailRow(
                      Icons.access_time,
                      'عدد الساعات المنجزة',
                      project.currentHours.toString(),
                    ),
                    _buildDetailRow(
                      Icons.attach_money,
                      'التكلفة الدنيا',
                      project.minCost.toString(),
                    ),
                    _buildDetailRow(
                      Icons.monetization_on,
                      'التكلفة الأعلى',
                      project.maxCost.toString(),
                    ),
                    _buildDetailRow(
                      Icons.price_check,
                      'التكلفة الحالية',
                      project.currentCost.toString(),
                    ),
                    _buildDetailRow(
                      Icons.calendar_month,
                      'التكلفة الشهرية',
                      project.currentMonthCost.toString(),
                    ),
                    _buildDetailRow(
                      Icons.account_tree_sharp,
                      'نسبة التقدم',
                      project.completionPercentage.toString(),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'التقدم:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Assigned Team Members Section
            Text(
              'أعضاء الفريق المعينون',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryColor,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            if (project.users.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'لا يوجد موظفون معينون لهذا المشروع.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: project.users.length,
                itemBuilder: (context, index) {
                  final user = project.users[index];
                  return BeautifulAssignedUserCard(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(
                            user: user,
                            project_id: project.projectModel.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, [
    Color? valueColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorManager.primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,

              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.black54,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
