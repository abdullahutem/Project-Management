import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/widgets/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<Project> projects = [
    Project(
      title: "تطبيق الجوال",
      user: UserModel(
        id: 1,
        name: 'عبدالله علي',
        phone: '0501234567',
        email: 'abdullah@example.com',
        base_salary: 2000,
        role: '',
      ),
    ),
    Project(
      title: "نظام الموارد البشرية",
      user: UserModel(
        id: 2,
        name: 'سارة محمد',
        phone: '0509876543',
        email: 'sarah@example.com',
        base_salary: 2000,
        role: '',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addProjectPage);
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'المشاريع',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: ColorManager.primaryColor,
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectCard(
            title: project.title,
            user: project.user,
            onEdit: () {
              // Handle edit here
              print("Edit ${project.title}");
            },
            onDelete: () {
              // Handle delete here
              print("Delete ${project.title}");
            },
          );
        },
      ),
    );
  }
}
