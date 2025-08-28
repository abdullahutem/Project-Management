import 'package:cmp/models/login_model.dart';
import 'package:cmp/models/single_project_model.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepo) : super(UserInitial());
  final UserRepo userRepo;

  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  LoginModel? loginModel;

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  String? selectedRole;
  List<UserModel> usersList = [];
  List<UserModel> usersForSingleProjectList = [];

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  List<UserModel> usersListPaginated = [];

  Future<void> getFirstPageUsers() async {
    emit(UsersLoading());
    currentPage = 1;
    final response = await userRepo.getUsersDataPaginated(currentPage);
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (
      paginated,
    ) {
      usersList = paginated.users;
      currentPage = paginated.currentPage;
      lastPage = paginated.lastPage;
      emit(UsersLoaded(usersList: usersList));
    });
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore || currentPage >= lastPage) return;

    isLoadingMore = true;
    final response = await userRepo.getUsersDataPaginated(currentPage + 1);
    response.fold(
      (error) {
        emit(UsersFaliure(errormessage: error));
        isLoadingMore = false;
      },
      (paginated) {
        usersList.addAll(paginated.users);
        currentPage = paginated.currentPage;
        lastPage = paginated.lastPage;
        emit(UsersLoaded(usersList: usersList));
        isLoadingMore = false;
      },
    );
  }

  signInUser() async {
    emit(SignInLoading());
    final response = await userRepo.signInUser(
      signInEmail: signInEmail.text,
      signInPassword: signInPassword.text,
    );
    response.fold(
      (error) => emit(SignInFaliure(errormessage: error)),
      (loginModel) => emit(SignInSucsess(message: loginModel.token)),
    );
  }

  logoutUser() async {
    emit(LogoutLoading());
    final response = await userRepo.logoutUser();
    response.fold((error) => emit(LogoutFaliure(logouterrormessage: error)), (
      logout,
    ) {
      print(
        "=======================================${LogoutSucsess(message: logout.message)}",
      );
      emit(LogoutSucsess(message: logout.message));
    });
  }

  getAllUsers() async {
    emit(UsersLoading());
    final response = await userRepo.getUsersData();
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (users) {
      usersList = users;
      emit(UsersLoaded(usersList: users));
    });
  }

  getAllUserNames() async {
    emit(UsersLoading());
    final response = await userRepo.getAllUsersNamesData();
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (users) {
      usersList = users;
      emit(UsersLoaded(usersList: users));
    });
  }

  deletelSingleUsers(int id) async {
    emit(UsersLoading());
    final response = await userRepo.deleteSingleUserData(id);
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (
      message,
    ) {
      emit(UserDeletedSuccess());
      getAllUsers();
    });
  }

  updateSingleUsers() async {
    emit(UsersLoading());
    final response = await userRepo.updateUser(
      id: idController.text,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      role: selectedRole.toString(),
      base_salary: salaryController.text,
    );
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (
      message,
    ) {
      emit(UsersUpdated(user: message));
      getAllUsers();
    });
  }

  addNewUser() async {
    emit(AddUserLoading());
    final response = await userRepo.addNewUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      role: selectedRole.toString(),
      base_salary: salaryController.text,
    );
    response.fold(
      (error) => emit(AddUserFaliure(errormessage: error)),
      (newUser) => emit(AddUserSucsess(newUser: newUser)),
    );
  }

  void updateRole(String? role) {
    selectedRole = role!;
    // emit(UserRoleUpdated()); // or any meaningful state
  }

  getSingleProjects(int id) async {
    emit(UsersLoading());
    final result = await userRepo.getSingleProjectsData(id);
    result.fold((error) => emit(UsersFaliure(errormessage: error)), (project) {
      usersForSingleProjectList = project.users;
      emit(SingleUserProjectLoaded(project: project, users: project.users));
    });
  }
}
