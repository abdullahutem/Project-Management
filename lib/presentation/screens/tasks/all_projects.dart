import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/tasks/tasks_page.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllProjects extends StatelessWidget {
  const AllProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProjectCubit(ProjectRepo(api: DioConsumer(dio: Dio())));
        cubit.getAllProjects(); // This loads the project data
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'المشاريع',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 6,
          shadowColor: ColorManager.primaryColor.withOpacity(0.6),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              final projects = context.read<ProjectCubit>().projectList;

              if (state is ProjectLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'جاري تحميل المشاريع...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProjectError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ: ${state.error}', // Displaying error message
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Optionally retry loading projects
                          context.read<ProjectCubit>().getAllProjects();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorManager.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (projects.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        color: Colors.grey[400],
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "لا توجد مشاريع لعرضها حاليًا.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "أضف مشروعًا جديدًا للبدء!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                itemCount: projects.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12, // Increased spacing
                  mainAxisSpacing: 12, // Increased spacing
                  childAspectRatio: 0.9, // Adjust card aspect ratio
                ),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    elevation: 4, // Add elevation for a card-like effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Softer corners
                    ),
                    clipBehavior: Clip.antiAlias, // Ensures content is clipped
                    child: InkWell(
                      onTap: () {
                        print(
                          "===========project.id====================${project.id}",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TasksPage(id: 21)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          // Optional: Add a border for subtle definition
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            12,
                          ), // Slightly less padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // You might want to add an icon related to projects here
                              Icon(
                                Icons.folder_copy_outlined, // Example icon
                                size: 40,
                                color: ColorManager.primaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                project.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                                maxLines: 2, // Allow project name to wrap
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
