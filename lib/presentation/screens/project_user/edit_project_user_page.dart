import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';

class EditProjectUserPage extends StatefulWidget {
  final int projectid;
  final int userid;
  final String userName;
  final String ptojectName;

  const EditProjectUserPage({
    Key? key,
    required this.projectid,
    required this.ptojectName,
    required this.userid,
    required this.userName,
  }) : super(key: key);

  @override
  State<EditProjectUserPage> createState() => _EditProjectUserPageState();
}

class _EditProjectUserPageState extends State<EditProjectUserPage> {
  @override
  void initState() {
    final cubit = context.read<ProjectUserCubit>();
    cubit.getSingleProjectUser(widget.projectid, widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectUserCubit>();
    return BlocConsumer<ProjectUserCubit, ProjectUserState>(
      listener: (context, state) {
        if (state is ProjectUserUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تعديل البيانات بنجاح")),
          );
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "${widget.ptojectName} تعديل المستخدم للمشروع",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
            backgroundColor: ColorManager.primaryColor,
            elevation: 0,
          ),
          body: BlocBuilder<ProjectUserCubit, ProjectUserState>(
            builder: (context, state) {
              if (state is ProjectUserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProjectUserError) {
                return Center(
                  child: Text(
                    'حدث خطأ: ${state.message}',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                );
              } else {
                return Form(
                  key: cubit.formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        "${widget.userName}  المستخدم",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),

                      const SizedBox(height: 10),

                      // START DATE
                      const Text(
                        "تاريخ البدء",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                cubit.startDateController.text.isNotEmpty
                                ? DateTime.parse(cubit.startDateController.text)
                                : DateTime.now(),
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

                      // END DATE
                      const Text(
                        "تاريخ الانتهاء",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: cubit.endDateController.text.isNotEmpty
                                ? DateTime.parse(cubit.endDateController.text)
                                : DateTime.now(),
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

                      // COST PER HOUR
                      const Text(
                        "أجرة الساعة",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      customTextField(
                        cubit.costPerHourController,
                        "أجرة الساعة",
                      ),
                      const SizedBox(height: 16),

                      // MIN HOURS
                      const Text(
                        "عدد الساعات الأدنى",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      customTextField(
                        cubit.minHoursController,
                        "عدد الساعات الأدنى",
                      ),
                      const SizedBox(height: 16),

                      // MAX HOURS
                      const Text(
                        "عدد الساعات الأعلى",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      customTextField(
                        cubit.maxHoursController,
                        "عدد الساعات الأعلى",
                      ),
                      const SizedBox(height: 30),

                      // SAVE BUTTON
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
                            cubit.updateSingleProjectUser(
                              userId: widget.userid.toString(),
                              projectId: widget.projectid.toString(),
                            );
                          }
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'حفظ التعديلات',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
