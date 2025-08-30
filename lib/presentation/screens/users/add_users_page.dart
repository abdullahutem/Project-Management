import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
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
        } else if (state is AddUserFaliure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة موظف',
              style: TextStyle(color: Colors.white, fontFamily: "EXPOARABIC"),
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
                    context.read<UserCubit>().nameController,
                    'الاسم الكامل',
                    icon: Icons.person,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'الرجاء إدخال الإسم' : null,
                  ),

                  customTextField(
                    icon: Icons.email,
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
                  customTextField(
                    context.read<UserCubit>().phoneController,
                    'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    icon: Icons.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? 'الرجاء إدخال رقم الهاتف'
                        : null,
                  ),

                  customTextField(
                    context.read<UserCubit>().passwordController,
                    'كلمة المرور',
                    obscureText: true,
                    icon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور ';
                      }
                    },
                  ),

                  customTextField(
                    context.read<UserCubit>().salaryController,
                    'الراتب الأساسي',
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money,
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
                    value: context.read<UserCubit>().selectedRole,
                    hintText: 'إختر الدور',
                    items: const [
                      DropdownMenuItem(value: 'employee', child: Text('موظف')),
                      DropdownMenuItem(value: 'admin', child: Text('مدير')),
                    ],
                    onChanged: (val) =>
                        context.read<UserCubit>().updateRole(val),
                    icon: Icons.security,
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
                        context.read<UserCubit>().addNewUser();
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'إضافة الموظف',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: "EXPOARABIC",
                      ),
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
