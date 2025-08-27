class ProjectSummaryModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String status;
  final bool isActive;
  final int createdBy;
  final int updatedBy;
  final int usersCount;
  final int tasksCount;
  final double completionPercentage;

  ProjectSummaryModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.usersCount,
    required this.tasksCount,
    required this.completionPercentage,
  });

  factory ProjectSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProjectSummaryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? false,
      createdBy: json['created_by'] ?? 0,
      updatedBy: json['updated_by'] ?? 0,
      usersCount: json['users_count'] ?? 0,
      tasksCount: json['tasks_count'] ?? 0,
      completionPercentage: (json['completion_percentage'] ?? 0).toDouble(),
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
      'created_by': createdBy,
      'updated_by': updatedBy,
      'users_count': usersCount,
      'tasks_count': tasksCount,
      'completion_percentage': completionPercentage,
    };
  }
}
