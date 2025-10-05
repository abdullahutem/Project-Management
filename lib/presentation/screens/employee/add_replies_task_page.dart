import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRepliesTaskPage extends StatefulWidget {
  final int task_id;
  const AddRepliesTaskPage({super.key, required this.task_id});

  @override
  State<AddRepliesTaskPage> createState() => _AddRepliesTaskPageState();
}

class _AddRepliesTaskPageState extends State<AddRepliesTaskPage> {
  @override
  void initState() {
    final cubit = context.read<TaskCubit>();
    cubit.idController.text = widget.task_id.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskCubit>();
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is AddRepliesTaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم إضافة الرد بنجاح"),
              backgroundColor: ColorManager.primaryColor,
            ),
          );
        } else if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorManager.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إضافة رد',
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
                      labelText: 'عنوان الرد',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال عنوان الرد';
                      }
                      return null;
                    },
                  ),
                  const Text(
                    "تاريخ البدء",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // START DATE & TIME PICKER
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final combined = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          cubit.updateStartDate(combined);
                        }
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
                  // END DATE & TIME PICKER
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final combined = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          cubit.updateEndDate(combined);
                        }
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

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (cubit.formKey.currentState!.validate()) {
                        await cubit.addTaskReplies();
                        cubit.idController.clear();
                        cubit.titleController.clear();
                        cubit.statusController.clear();
                        // if (replyAddedSuccessfully) {
                        Navigator.pop(context, true);
                        // }
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'إضافة الرد',
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
