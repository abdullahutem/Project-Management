class EndPoint {
  static String baseUrl = "http://127.0.0.1:8000/api/";
  static String login = "login";
  static String logout = "logout";
  static String users = "users";
  static String projects = "projects";
  static String task = "tasks";
  static String project_users = "project-users";
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

  static String updateUserEndPoint(String id) {
    return "users/$id";
  }

  static String updateTaskEndPoint(String id) {
    return "tasks/$id";
  }

  static String updateTaskRepliesEndPoint(String id) {
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
  static String project_name = "project_name";
  static String user_name = "user_name";
  static String note = "note";
}
