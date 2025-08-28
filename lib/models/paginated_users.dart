import 'package:cmp/models/user_model.dart';

class PaginatedUsers {
  final List<UserModel> users;
  final int currentPage;
  final int lastPage;

  PaginatedUsers({
    required this.users,
    required this.currentPage,
    required this.lastPage,
  });
}
