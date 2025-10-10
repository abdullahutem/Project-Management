class EndPoint {
  static String baseUrl = "http://127.0.0.1:8000/api/";
  // static String baseUrl = "http://10.0.2.2:8000/api/";
  // static String baseUrl = "http://10.0.2.2:8000/api/";

  static String login = "login";
  static String logout = "logout";
  static String users = "users";
  static String projects = "projects";
  static String financial_report = "financial-report";
  static String task = "tasks";
  static String task_replies = "task-replies";
  static String project_users = "project-users";
  static String stats = "stats";
  static String getUserDataEndPoint(int id) {
    return "users/$id";
  }

  static String getSingleTaskEndPoint(int id) {
    return "tasks/$id";
  }

  static String getUserTaskInSpecificProjectEndPoint(
    int project_id,
    int user_id,
  ) {
    return "project-users/$project_id/$user_id";
  }

  static String getPrjectForSpecificUserEndPoint(int user_id) {
    return "users/$user_id/projects";
  }

  static String getSingleProjectDataEndPoint(int id) {
    return "projects/$id";
  }

  static String getTaskEndPoint(int id) {
    return "project-users/$id/tasks";
  }

  static String getProjectDataEndPoint(int id) => 'projects/$id';
  static String getProjectUserDataEndPoint(int id) => 'project-user/$id';
  static String deletProjectUserDataEndPoint(int project_id, int user_id) =>
      'project-users/$project_id/$user_id';
  static String updateProjectUserDataEndPoint(
    String project_id,
    String user_id,
  ) => 'project-users/$project_id/$user_id';

  static String updateUserEndPoint(String id) {
    return "users/$id";
  }

  static String updateTaskEndPoint(String id) {
    return "tasks/$id";
  }

  static String updateTaskRepliesEndPoint(int id) {
    return "task-replies/$id";
  }

  static String deleteTaskEndPoint(int id) {
    return "tasks/$id";
  }
}

class ApiKeys {
  static String id = "id";
  static String status = "status";
  static String email = "email";
  static String password = "password";
  static String message = "message";
  static String errors = "errors";
  static String token = "token";
  static String name = "name";
  static String phone = "phone";
  static String role = "role";
  static String base_salary = "base_salary";
  static String startDate = "start_date";
  static String endDate = "end_date";
  static String is_active = "is_active";
  static String task = "task";
  static String task_id = "task_id";
  static String project_user_id = "project_user_id";
  static String created_by = "created_by";
  static String updated_by = "updated_by";
  static String replies_count = "replies_count";
  static String current_cost = "current_cost";
  static String project_name = "project_name";
  static String user_name = "user_name";
  static String note = "note";
  static String total_hours = "total_hours";
  static String total_cost = "total_cost";
  static String entries_count = "entries_count";
  static String projects_count = "projects_count";
  static String task_pending_counts = "task_pending_counts";
  static String task_active_counts = "task_active_counts";
  static String task_completed_counts = "task_completed_counts";
  static String project_summary = "project_summary";
}
