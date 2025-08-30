import 'package:animate_do/animate_do.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // 1. Form key

    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(UserRepo(api: DioConsumer(dio: Dio()))),
      child: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is SignInSucsess) {
            Navigator.pushReplacementNamed(context, Routes.homePage);
          } else if (state is SignInFaliure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errormessage)));
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Background and title
                SizedBox(
                  height: 400,
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage('assets/images/background.png'),
                  //     fit: BoxFit.fill,
                  //     colorFilter: ColorFilter.mode(
                  //       ColorManager.primaryColor,
                  //       BlendMode.darken,
                  //     ),
                  //   ),
                  // ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: const Image(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: const Image(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: const Image(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            // color: Colors.white,
                            height: 200,
                            width: 200,
                            margin: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: Image.asset(
                                "assets/images/logowhite.png",
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form with email and password
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return Form(
                        key: _formKey, // 2. Attach form key
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorManager.primaryColor,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, 0.2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ColorManager.primaryColor,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: context
                                            .read<UserCubit>()
                                            .signInEmail,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "البريد الإلكتروني",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "الرجاء إدخال البريد الإلكتروني";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: context
                                            .read<UserCubit>()
                                            .signInPassword,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "كلمة المرور",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "الرجاء إدخال كلمة المرور";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Login Button
                            FadeInDownBig(
                              duration: const Duration(milliseconds: 1900),
                              child: state is SignInLoading
                                  ? const CircularProgressIndicator()
                                  : GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<UserCubit>()
                                              .signInUser();
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: ColorManager.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "تسجيل الدخول",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
