import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskPage extends StatefulWidget {
  final int projectUserId;
  const AddTaskPage({super.key, required this.projectUserId});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  void initState() {
    final taskCubit = context.read<TaskCubit>();
    taskCubit.projectUserIdController.text = widget.projectUserId.toString();
    taskCubit.statusController.text = "Completed";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskCubit>();
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم إضافة المهمة بنجاح"),
              backgroundColor: ColorManager.primaryColor,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is TaskError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة مهمة',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cubit.titleController,
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Active',
                        child: Text(
                          'نشيط',
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
                  const SizedBox(height: 30),
                  BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        title: const Text(
                          'هل المهمة مفعلة؟',
                          style: const TextStyle(
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (cubit.formKey.currentState!.validate()) {
                        cubit.addNewTask();
                        cubit.projectUserIdController.clear();
                        cubit.titleController.clear();
                        cubit.statusController.clear();
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'إضافة المهمة',
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
