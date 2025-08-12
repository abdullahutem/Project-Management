class ProjectModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final String status;
  final bool isActive;
  final int createdBy;
  final int updatedBy;
  // "id": 1,
  //           "name": "Stehr LLC",
  //           "start_date": "1991-06-04",
  //           "end_date": "2023-08-19",
  //           "status": "pending",
  //           "is_active": 1

  ProjectModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["data"]["id"],
      name: json["data"]["name"],
      startDate: json["data"]["start_date"],
      endDate: json["data"]["end_date"],
      status: json["data"]["status"],
      isActive: json["data"]["is_active"],
      createdBy: json["data"]["created_by"],
      updatedBy: json["data"]["updated_by"],
    );
  }
  factory ProjectModel.fromJsonNoData(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      status: json["status"],
      isActive: json["is_active"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
    );
  }
}
