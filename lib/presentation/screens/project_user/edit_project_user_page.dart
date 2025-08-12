import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/models/project_user_model.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProjectUserPage extends StatefulWidget {
  final ProjectUserModel model;
  final int project_id;
  final int user_id;

  const EditProjectUserPage({
    super.key,
    required this.model,
    required this.project_id,
    required this.user_id,
  });

  @override
  State<EditProjectUserPage> createState() => _EditProjectUserPageState();
}

class _EditProjectUserPageState extends State<EditProjectUserPage> {
  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل المستخدم في المشروع')),
      body: Form(
        key: _formKey,
        child: BlocBuilder<ProjectUserCubit, ProjectUserState>(
          builder: (context, state) {
            final cubit = context.read<ProjectUserCubit>();

            return BlocBuilder<UserCubit, UserState>(
              builder: (context, userState) {
                return BlocBuilder<ProjectCubit, ProjectState>(
                  builder: (context, projectState) {
                    final users = context.watch<UserCubit>().usersList;
                    final projects = context.watch<ProjectCubit>().projectList;

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'اسم المستخدم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        customDropdownField(
                          value: widget.user_id.toString(),
                          items: users.map((user) {
                            return DropdownMenuItem<String>(
                              value: user.id.toString(),
                              child: Text(user.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            cubit.selectedUserId = val ?? '';
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'اسم المشروع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        customDropdownField(
                          value: widget.project_id.toString(),
                          items: projects.map((proj) {
                            return DropdownMenuItem<String>(
                              value: proj.id.toString(),
                              child: Text(proj.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            cubit.selectedProjectId = val ?? '';
                            print(cubit.selectedProjectId);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.updateSingleProjectUser(widget.model.id);
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text('تحديث'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
