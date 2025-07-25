import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/widgets/dashboard_card.dart'; // Ensure this widget is updated as suggested below
import 'package:cmp/presentation/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart'; // Assuming this defines your primary colors

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text(
          'لوحة التحكم',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22, // Slightly larger title
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 6, // Increased elevation for a more prominent app bar
        // Optional: Add a shadow color to match app bar
        shadowColor: ColorManager.primaryColor.withOpacity(0.6),
      ),
      body: Container(
        // Optional: A subtle background gradient or pattern for the body
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade100, // Very light top
              Colors.white, // White bottom
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // Increased padding for more breathing room
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prominent Welcome Section
              Text(
                'مرحباً بك!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'نظرة سريعة على بياناتك',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30), // More space before cards

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0, // Increased spacing
                  mainAxisSpacing: 20.0, // Increased spacing
                  childAspectRatio:
                      0.9, // Adjust card ratio for a slightly taller look
                  children: [
                    DashboardCard(
                      icon: Icons.groups_2_outlined, // Modern icon
                      label: 'الموظفين', // Simplified label
                      count: 12,
                      // Using a specific color for the gradient base
                      baseColor: Colors.blue.shade700,
                      function: () {
                        Navigator.pushNamed(context, Routes.usersPage);
                      },
                    ),
                    DashboardCard(
                      icon: Icons.business_center_outlined, // Modern icon
                      label: 'المشاريع',
                      count: 5,
                      baseColor: Colors.green.shade700,
                      function: () {
                        Navigator.pushNamed(context, Routes.projectPage);
                      },
                    ),
                    DashboardCard(
                      icon: Icons.checklist_rtl_outlined, // Modern icon
                      label: 'المهام',
                      count: 23,
                      baseColor: Colors.orange.shade700,
                      function: () {
                        Navigator.pushNamed(context, Routes.taskPage);
                      },
                    ),
                    DashboardCard(
                      icon: Icons.analytics_outlined, // Modern icon for reports
                      label: 'التقارير',
                      count: 12, // Still supports no count
                      baseColor: Colors.purple.shade700,
                      function: () {
                        // Implement navigation to reports page
                        // Navigator.pushNamed(context, Routes.reportsPage);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
