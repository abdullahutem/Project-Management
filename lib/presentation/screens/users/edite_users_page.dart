import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditeUsersPage extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String salary;
  final String role;

  const EditeUsersPage({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.salary,
    required this.role,
  });

  @override
  State<EditeUsersPage> createState() => _EditeUsersPageState();
}

class _EditeUsersPageState extends State<EditeUsersPage> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();

    final userCubit = context.read<UserCubit>();

    userCubit.idController.text = widget.id;
    userCubit.nameController.text = widget.name;
    userCubit.emailController.text = widget.email;
    userCubit.phoneController.text = widget.phone;
    userCubit.salaryController.text = widget.salary;
    userCubit.roleController.text = widget.role;
    userCubit.selectedRole = widget.role;

    print("name in the Edit user screen=================${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UsersUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تعديل الموظف بنجاح")),
          );
        } else if (state is UsersFaliure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<UserCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'تعديل الموظف',
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
                  customTextField(
                    cubit.nameController,
                    'الاسم الكامل',
                    icon: Icons.person,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'الرجاء إدخال الإسم' : null,
                  ),
                  customTextField(
                    cubit.emailController, // ✅ This is a TextEditingController
                    'البريد الإلكتروني',
                    icon: Icons.email,
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
                  customTextField(
                    cubit.phoneController,
                    'رقم الهاتف',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? 'الرجاء إدخال رقم الهاتف'
                        : null,
                  ),
                  customTextField(
                    cubit.passwordController,
                    'كلمة المرور',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  customTextField(
                    cubit.salaryController,
                    'الراتب الأساسي',
                    icon: Icons.attach_money,
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
                  const SizedBox(height: 16),
                  customDropdownField(
                    value: cubit.selectedRole,
                    icon: Icons.security,
                    items: const [
                      DropdownMenuItem(value: 'employee', child: Text('موظف')),
                      DropdownMenuItem(value: 'admin', child: Text('مدير')),
                    ],
                    onChanged: (val) => cubit.updateRole(val),
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
                        cubit.updateSingleUsers();
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'تحديث البيانات',
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
}
