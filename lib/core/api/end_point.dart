class EndPoint {
  static String baseUrl = "http://127.0.0.1:8000/api/";
  static String login = "login";
  static String users = "users";
  static String getUserDataEndPoint(int id) {
    return "users/$id";
  }

  static String updateUserEndPoint(String id) {
    return "users/$id";
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
}
