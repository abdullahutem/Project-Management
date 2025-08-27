import 'package:cmp/models/projects_model.dart';

class ProjectsOfUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String baseSalary;
  final List<ProjectsModel> projects;

  ProjectsOfUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.baseSalary,
    required this.projects,
  });

  factory ProjectsOfUserModel.fromJson(Map<String, dynamic> json) {
    return ProjectsOfUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      baseSalary: json['base_salary'] as String,
      projects: (json['projects'] as List)
          .map((item) => ProjectsModel.fromJson(item))
          .toList(),
    );
  }
}
