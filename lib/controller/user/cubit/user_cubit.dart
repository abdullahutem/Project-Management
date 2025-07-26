import 'package:cmp/models/login_model.dart';
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

  // signInUser() async {
  //   try {
  //     emit(SignInLoading());
  //     final response = await userRepo.siginUser(
  //       signInEmail: signInEmail.text,
  //       signInPassword: signInPassword.text,
  //     );
  //     if (response != null) {
  //       emit(SignInSucsess(message: loginModel!.token));
  //     }
  //   } on ServerException catch (e) {
  //     emit(SignInFaliure(errormessage: e.errorModel.message));
  //   } catch (e) {
  //     emit(SignInFaliure(errormessage: 'Unexpected error: $e'));
  //   }
  // }

  signInUser() async {
    emit(SignInLoading());
    final response = await userRepo.siginUser(
      signInEmail: signInEmail.text,
      signInPassword: signInPassword.text,
    );
    print("=================***********=====${response}");

    response.fold(
      (error) => emit(SignInFaliure(errormessage: error)),
      (loginModel) => emit(SignInSucsess(message: loginModel.token)),
    );
  }

  getAllUsers() async {
    emit(UsersLoading());
    final response = await userRepo.getUsersData();
    print("=================***********=====${response}");

    response.fold(
      (error) => emit(UsersFaliure(errormessage: error)),
      (users) => emit(UsersLoaded(usersList: users)),
    );
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
      password: passwordController.text,
      phone: phoneController.text,
      role: roleController.text,
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
    print("=================***********=====${response}");

    response.fold(
      (error) => emit(AddUserFaliure(errormessage: error)),
      (newUser) => emit(AddUserSucsess(newUser: newUser)),
    );
  }

  void updateRole(String? role) {
    selectedRole = role!;
    //emit(UserRoleUpdated()); // or any meaningful state
  }
}
