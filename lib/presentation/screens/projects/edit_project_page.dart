import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProjectPage extends StatefulWidget {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String status;
  final bool isActive;

  const EditProjectPage({
    super.key,
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
  });

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProjectCubit>();
    cubit.nameController.text = widget.name;
    cubit.startDateController.text = widget.startDate;
    cubit.endDateController.text = widget.endDate;
    cubit.statusController.text = widget.status;
    cubit.isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is ProjectUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعديل المشروع بنجاح')),
          );
        } else if (state is ProjectError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProjectCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'تعديل المشروع',
              style: const TextStyle(color: Colors.white),
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
                  const Text(
                    "اسم المشروع",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  customTextField(
                    cubit.nameController,
                    'اسم المشروع',
                    icon: Icons.work,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'الرجاء إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تاريخ البدء',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  customTextField(
                    cubit.startDateController,
                    'تاريخ البدء',
                    icon: Icons.date_range,
                    validator: (v) => v == null || v.isEmpty
                        ? 'الرجاء إدخال تاريخ البدء'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تاريخ الانتهاء',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  customTextField(
                    cubit.endDateController,
                    'تاريخ الانتهاء',
                    icon: Icons.event,
                    validator: (v) => v == null || v.isEmpty
                        ? 'الرجاء إدخال تاريخ الانتهاء'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "حالة المشروع",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  customDropdownField(
                    value: cubit.statusController.text,
                    icon: Icons.info,
                    items: const [
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text(
                          'قيد الانتظار',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text(
                          'مكتمل',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'active',
                        child: Text(
                          'مفعل',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => cubit.statusController.text = val ?? '',
                  ),
                  SwitchListTile(
                    title: const Text(
                      'المشروع مفعل؟',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: cubit.isActive!,
                    onChanged: cubit.updateIsActive,
                    activeColor: ColorManager.primaryColor,
                    secondary: const Icon(Icons.check_circle),
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
                        cubit.updateSingleProject(widget.id);
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'تحديث البيانات',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
