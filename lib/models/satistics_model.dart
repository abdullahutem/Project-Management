class SatisticsModel {
  // "projects_count": 30,
  //       "users_count": 20,
  //       "tasks_count": 100

  final int projects_count;
  final int users_count;
  final int tasks_count;

  SatisticsModel({
    required this.projects_count,
    required this.users_count,
    required this.tasks_count,
  });
  factory SatisticsModel.fromJson(Map<String, dynamic> json) {
    return SatisticsModel(
      projects_count: json['data']['projects_count'],
      users_count: json['data']['users_count'],
      tasks_count: json['data']['tasks_count'],
    );
  }
}
