import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/employee_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // You can show a snackbar or alert on failure here
        if (state is UsersFaliure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        } else if (state is UserDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم حذف الموظف"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorManager.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addUsersPage,
              );
              if (result == true) {
                context.read<UserCubit>().getAllUsers(); // Refresh the list
              }
            },
          ),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'الموظفين',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            backgroundColor: ColorManager.primaryColor,
          ),
          body: Builder(
            builder: (_) {
              if (state is UsersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UsersLoaded) {
                final List<UserModel> employees = state.usersList;
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final emp = employees[index];
                    return EmployeeCard(
                      name: emp.name,
                      phone: emp.phone,
                      role: emp.role,
                      onEdit: () => print('Delete ${emp.name}'),

                      onDelete: () =>
                          context.read<UserCubit>().deletelSingleUsers(emp.id),
                    );
                  },
                );
              } else if (state is UsersFaliure) {
                return Center(child: Text('حدث خطأ: ${state.errormessage}'));
              } else {
                return const SizedBox(); // default empty state
              }
            },
          ),
        );
      },
    );
  }
}
