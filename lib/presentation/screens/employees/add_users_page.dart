import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({super.key});

  @override
  State<AddUsersPage> createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is AddUserSucsess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("تم إضافة الموظف الجديد")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة موظف',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    context.read<UserCubit>().nameController,
                    'الاسم الكامل',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    context.read<UserCubit>().phoneController,
                    'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? 'الرجاء إدخال رقم الهاتف'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    context.read<UserCubit>().emailController,
                    'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'البريد الإلكتروني غير صالح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown for role
                  DropdownButtonFormField<String>(
                    value: context.read<UserCubit>().selectedRole,
                    decoration: InputDecoration(
                      labelText: 'الدور',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: const [
                      DropdownMenuItem(value: 'employee', child: Text('موظف')),
                      DropdownMenuItem(value: 'admin', child: Text('مدير')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        //context.read<UserCubit>().selectedRole = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'الرجاء اختيار الدور'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Base salary field
                  _buildTextField(
                    context.read<UserCubit>().salaryController,
                    'الراتب الأساسي',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الراتب';
                      }
                      if (double.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صالح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Form is valid. Employee saved:");
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'إضافة الموظف',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) => value == null || value.isEmpty ? 'مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
