import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/project_user/add_project_user_page_for_user.dart';
import 'package:cmp/presentation/screens/users/user_details_page.dart';

import 'package:cmp/presentation/widgets/project_card_no_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsWithProjectPage extends StatefulWidget {
  final int user_id;
  final String user_name;
  const UserDetailsWithProjectPage({
    super.key,
    required this.user_id,
    required this.user_name,
  });

  @override
  State<UserDetailsWithProjectPage> createState() =>
      _UserDetailsWithProjectPageState();
}

class _UserDetailsWithProjectPageState
    extends State<UserDetailsWithProjectPage> {
  @override
  void initState() {
    context.read<ProjectCubit>().getProjectsForSpecificUser(widget.user_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.user_name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProjectUserPageForUser(
                userid: widget.user_id,
                userName: widget.user_name,
              ),
            ),
          );
          if (result == true) {
            // ✅ refresh projects after successful add
            context.read<ProjectCubit>().getProjectsForSpecificUser(
              widget.user_id,
            );
          }
        },
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'أضف مشروع للموظف',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorManager.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                'المشاريع المعينة',
                style: const TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1),
            BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProjectError) {
                  return Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is ProjectsUserLoaded) {
                  final theprojects = state.project;
                  if (theprojects.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'لا توجد مشاريع معينة لهذا الموظف.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: theprojects.length,
                      itemBuilder: (context, index) {
                        final project = theprojects[index];
                        return ProjectCardNoEdit(
                          projectModel: project,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailsPage(
                                  project_id: project.project.id,
                                  user_id: widget.user_id,
                                  user_name: widget.user_name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
