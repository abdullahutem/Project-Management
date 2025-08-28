import 'package:cmp/models/projects_model.dart';

class PafinatedProjects {
  final List<ProjectsModel> projects;
  final int currentPage;
  final int lastPage;

  PafinatedProjects({
    required this.projects,
    required this.currentPage,
    required this.lastPage,
  });
}
