class UserSummaryModel {
  final String name;
  final int projectsCount;
  final int tasksCount;
  final String baseSalary;
  final double totalHours;
  final double totalCost;

  UserSummaryModel({
    required this.name,
    required this.projectsCount,
    required this.tasksCount,
    required this.baseSalary,
    required this.totalHours,
    required this.totalCost,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      name: json['name'] ?? "",
      projectsCount: json['projects_count'] ?? 0,
      tasksCount: json['tasks_count'] ?? 0,
      baseSalary: json['base_salary'] ?? "0.0",
      totalHours: json['total_hours'] ?? 0,
      totalCost: json['total_cost'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'projects_count': projectsCount,
      'tasks_count': tasksCount,
      'base_salary': baseSalary,
      'total_hours': totalHours,
      'total_cost': totalCost,
    };
  }
}
