import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  // Sample employee list (in real app, fetch from a data source)
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

  UserModel? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة مشروع',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Project Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'اسم المشروع',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم المشروع';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown to select Employee
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
                onChanged: (UserModel? value) {
                  setState(() {
                    selectedEmployee = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'يرجى اختيار الموظف';
                  }
                  return null;
                },
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
                      // Will process the form later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: ColorManager.primaryColor,
                          content: Text(
                            'تمت إضافة المشروع بنجاح!',
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
                    'إضافة المشروع',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
