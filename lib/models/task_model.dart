import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/project_model.dart';

class Task {
  final int id;
  final String title;
  final Project project;
  final UserModel user;

  Task({
    required this.id,
    required this.title,
    required this.project,
    required this.user,
  });
}
