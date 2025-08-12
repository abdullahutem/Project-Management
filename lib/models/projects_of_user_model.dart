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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'base_salary': baseSalary,
    };
  }
}

class ProjectsModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String status;
  final int isActive;

  ProjectsModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
  });

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      status: json['status'] as String,
      isActive: json['is_active'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'is_active': isActive,
    };
  }
}
