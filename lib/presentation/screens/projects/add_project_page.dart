import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectCubit>();

    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is AddProjectSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إضافة الموظف للمشروع بنجاح")),
          );
          Navigator.pop(context, true);
        } else if (state is AddProjectFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة مشروع',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: cubit.formKey,
              child: ListView(
                children: [
                  const Text(
                    "اسم المشروع",
                    style: TextStyle(
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
                    "تاريخ البدء",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // START DATE PICKER
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        cubit.updateStartDate(picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: customTextField(
                        cubit.startDateController,
                        'تاريخ البدء',
                        icon: Icons.date_range,
                        validator: (v) => v == null || v.isEmpty
                            ? 'الرجاء إدخال تاريخ البدء'
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "تاريخ الانتهاء",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // END DATE PICKER
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        cubit.updateEndDate(picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: customTextField(
                        cubit.endDateController,
                        'تاريخ الانتهاء',
                        icon: Icons.event,
                        validator: (v) => v == null || v.isEmpty
                            ? 'الرجاء إدخال تاريخ الانتهاء'
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "حالة المشروع",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  customDropdownField(
                    hintText: 'إختر الحالة',
                    value: cubit.statusController.text.isEmpty
                        ? "Pending"
                        : cubit.statusController.text,
                    icon: Icons.info,
                    items: const [
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Text(
                          'قيد الانتظار',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Completed',
                        child: Text(
                          'مكتمل',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => cubit.statusController.text = val ?? '',
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ProjectCubit, ProjectState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        title: const Text(
                          'هل المشروع مفعل؟',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: cubit.isUpdateValue,
                        onChanged: cubit.updateValue,
                        activeColor: ColorManager.primaryColor,
                        secondary: const Icon(Icons.check_circle),
                      );
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
                      if (cubit.formKey.currentState!.validate()) {
                        cubit.addNewProject();
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'إضافة المشروع',
                      style: TextStyle(
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
