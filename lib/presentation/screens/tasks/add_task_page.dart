import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  // Sample data — Replace with your actual sources
  List<UserModel> employees = [
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

  List<Project> projects = [
    Project(
      title: 'مشروع المتابعة',
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
      title: 'تطبيق المبيعات',
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

  UserModel? selectedEmployee;
  Project? selectedProject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مهمة', style: TextStyle(color: Colors.white)),
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Task Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المهمة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Select Project
              DropdownButtonFormField<Project>(
                value: selectedProject,
                decoration: const InputDecoration(
                  labelText: 'اختر المشروع',
                  border: OutlineInputBorder(),
                ),
                items: projects.map((proj) {
                  return DropdownMenuItem<Project>(
                    value: proj,
                    child: Text(proj.title),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedProject = value),
                validator: (value) =>
                    value == null ? 'يرجى اختيار المشروع' : null,
              ),

              const SizedBox(height: 20),

              // Select Employee
              DropdownButtonFormField<UserModel>(
                value: selectedEmployee,
                decoration: const InputDecoration(
                  labelText: 'اختر الموظف',
                  border: OutlineInputBorder(),
                ),
                items: employees.map((emp) {
                  return DropdownMenuItem<UserModel>(
                    value: emp,
                    child: Text(emp.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedEmployee = value),
                validator: (value) =>
                    value == null ? 'يرجى اختيار الموظف' : null,
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: ColorManager.primaryColor,
                          content: Text(
                            'تمت إضافة المهمة بنجاح!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'إضافة المهمة',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
