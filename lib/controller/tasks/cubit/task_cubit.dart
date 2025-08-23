import 'package:bloc/bloc.dart';
import 'package:cmp/models/project_user_model.dart';
import 'package:cmp/models/single_task_model.dart';
import 'package:cmp/models/task_model.dart';
import 'package:cmp/models/task_replies_model.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.taskRepo) : super(TaskInitial());
  final TaskRepo taskRepo;
  String? selectedStatus;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController projectUserIdController = TextEditingController();
  TextEditingController idController = TextEditingController();
  bool isUpdateValue = true;
  bool? isActive;
  void updateIsActive(bool value) {
    isActive = value;
    emit(TaskIsActiveChanged());
  }

  void updateRole(String? status) {
    selectedStatus = status!;
  }

  void updateValue(bool value) {
    isUpdateValue = value;
    emit(TaskIsActiveChanged());
  }

  void resetTaskForm() {
    idController.clear();
    titleController.clear();
    statusController.clear();
    projectUserIdController.clear();
    isActive = false;
  }

  void getAllTasks(int id) async {
    emit(TaskLoading());
    final result = await taskRepo.getTasksData(id);
    result.fold(
      (error) => emit(TaskError(error)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }

  void getUserTasksForSpecificProjet(int project_id, int user_id) async {
    emit(TaskLoading());
    final result = await taskRepo.getTasksUserInSpecificProjectData(
      project_id,
      user_id,
    );
    result.fold(
      (error) => emit(TaskError(error)),
      (tasks) => emit(TasksUserLoaded(tasks: tasks)),
    );
  }

  void getSingeleTask(int task_id) async {
    emit(TaskLoading());
    final result = await taskRepo.getSingleTaskData(task_id);
    result.fold(
      (error) => emit(TaskError(error)),
      (tasks) => emit(SingleTaskLoaded(task: tasks)),
    );
  }

  addNewTask() async {
    emit(AddTaskLoading());
    final response = await taskRepo.addNewTask(
      task: titleController.text,
      project_user_id: projectUserIdController.text,
      status: statusController.text,
      isActive: isUpdateValue,
    );

    response.fold(
      (error) => emit(TaskError(error)),
      (newTask) => emit(AddTaskSuccess(tasks: newTask)),
    );
  }

  deletelSingleTask(int id) async {
    emit(TaskLoading());
    final response = await taskRepo.deleteTaskData(id);
    response.fold((error) => emit(TaskError(error)), (message) {
      emit(TaskDeletedSuccess());
    });
  }

  updateSingleTask() async {
    emit(TaskLoading());
    final response = await taskRepo.updateTask(
      id: idController.text,
      task: titleController.text,
      status: statusController.text,
      isActive: isActive!,
      projectUserId: projectUserIdController.text,
    );
    response.fold((error) => emit(TaskError(error)), (message) {
      emit(TaskUpdated(task: message));
    });
  }

  updateTaskStatus(String id, String status, bool is_active) async {
    emit(TaskLoading());
    final response = await taskRepo.updateTaskStatus(
      id: id,
      status: status,
      is_active: is_active,
    );
    response.fold((error) => emit(TaskError(error)), (message) {
      emit(TaskUpdated(task: message));
    });
  }

  updateRepliesTaskStatus(String id, String status) async {
    emit(TaskLoading());
    final response = await taskRepo.updateTaskRepliesStatus(
      id: id,
      status: status,
    );
    response.fold((error) => emit(TaskError(error)), (message) {
      emit(TaskRepliesUpdated(task: message));
    });
  }
}
