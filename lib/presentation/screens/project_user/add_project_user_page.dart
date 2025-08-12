import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProjectUserPage extends StatefulWidget {
  const AddProjectUserPage({super.key});

  @override
  State<AddProjectUserPage> createState() => _AddProjectUserPageState();
}

class _AddProjectUserPageState extends State<AddProjectUserPage> {
  @override
  void initState() {
    final userCubit = context.read<UserCubit>();
    final projectCubit = context.read<ProjectCubit>();
    userCubit.getAllUsers();
    projectCubit.getAllProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectUserCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("إضافة مستخدم لمشروع")),
      body: Form(
        key: cubit.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "المستخدم",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: "EXPOARABIC",
              ),
            ),
            customDropdownField(
              value: cubit.selectedUserId,
              items: context.watch<UserCubit>().usersList.map((u) {
                return DropdownMenuItem(
                  value: u.id.toString(),
                  child: Text(u.name),
                );
              }).toList(),
              onChanged: (val) => cubit.selectedUserId = val ?? '',
            ),
            const Text(
              "المشروع",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            customDropdownField(
              value: cubit.selectedProjectId,
              items: context.read<ProjectCubit>().projectList.map((p) {
                return DropdownMenuItem(
                  value: p.id.toString(),
                  child: Text(p.name),
                );
              }).toList(),
              onChanged: (val) => cubit.selectedProjectId = val ?? '',
            ),
            const SizedBox(height: 10),
            const Text(
              "تاريخ البدء",
              style: TextStyle(fontWeight: FontWeight.bold),
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
              "أجرة الساعة",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            customTextField(cubit.costPerHourController, "أجرة الساعة"),
            const SizedBox(height: 16),

            const Text(
              "عدد الساعات الأدنى",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            customTextField(cubit.minHoursController, "عدد الساعات الأدنى"),
            const SizedBox(height: 16),

            const Text(
              "عدد الساعات الأعلى",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            customTextField(cubit.maxHoursController, "عدد الساعات الأعلى"),

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
                  cubit.addNewProjectUser();
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'إضافة المشروع',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
