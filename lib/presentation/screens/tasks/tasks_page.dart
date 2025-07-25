import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';

class Task {
  final int id;
  final String title;
  final Project project;
  final UserModel employee;

  Task({
    required this.id,
    required this.title,
    required this.project,
    required this.employee,
  });
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<UserModel> employees = [
    UserModel(
      id: 1,
      name: 'عبدالله علي',
      phone: '0501234567',
      email: 'abdullah@example.com',
      base_salary: 2000,
      role: '',
    ),
    UserModel(
      id: 2,
      name: 'سارة محمد',
      phone: '0509876543',
      email: 'sarah@example.com',
      base_salary: 2000,
      role: '',
    ),
  ];

  final List<Project> projects = [
    Project(
      title: 'مشروع النظام الإداري',
      user: UserModel(
        id: 2,
        name: 'سارة محمد',
        phone: '0509876543',
        email: 'sarah@example.com',
        base_salary: 2000,
        role: '',
      ),
    ),
    Project(
      title: 'تطبيق الهاتف',
      user: UserModel(
        id: 1,
        name: 'عبدالله علي',
        phone: '0501234567',
        email: 'abdullah@example.com',
        base_salary: 2000,
        role: '',
      ),
    ),
  ];

  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [
      Task(
        id: 1,
        title: 'تحليل النظام',
        project: projects[0],
        employee: employees[0],
      ),
      Task(
        id: 2,
        title: 'تصميم واجهة المستخدم',
        project: projects[1],
        employee: employees[1],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المهام', style: TextStyle(color: Colors.white)),
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addTaskPage);
        },
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              children: [
                // Task Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow('المهمة: ', task.title),
                      const SizedBox(height: 8),
                      _buildRow('المشروع: ', task.project.title),
                      const SizedBox(height: 8),
                      _buildRow('الموظف: ', task.employee.name),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    print("Edit task ${task.title}");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    print("Delete task ${task.title}");
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
