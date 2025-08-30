import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTaskPage extends StatefulWidget {
  final String id;
  final String task;
  final String status;
  final bool isActive;
  final String projectUserId;

  const EditTaskPage({
    super.key,
    required this.id,
    required this.task,
    required this.status,
    required this.isActive,
    required this.projectUserId,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TaskCubit taskCubit;

  @override
  void initState() {
    super.initState();
    taskCubit = context.read<TaskCubit>();
    taskCubit.idController.text = widget.id;
    taskCubit.titleController.text = widget.task;
    taskCubit.statusController.text = widget.status;
    taskCubit.isActive = widget.isActive;
    taskCubit.projectUserIdController.text = widget.projectUserId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<TaskCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'تعديل المهمة',
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
                    cubit.titleController,
                    'عنوان المهمة',
                    icon: Icons.task,
                    validator: (v) => v!.isEmpty ? 'الرجاء إدخال المهمة' : null,
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    "حالة المهمة",
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
                          style: const TextStyle(
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
                          'مفعل',
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
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.updateSingleTask();
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'تحديث المهمة',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
