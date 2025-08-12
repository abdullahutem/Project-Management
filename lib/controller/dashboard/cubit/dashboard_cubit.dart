import 'package:bloc/bloc.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  static DashboardCubit get(context) => BlocProvider.of(context);

  int usersCount = 0;
  int projectsCount = 0;
  int tasksCount = 0;

  final Dio _dio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));

  Future<void> fetchDashboardData() async {
    emit(DashboardLoading());

    try {
      final usersResponse = await _dio.get('users');
      final projectsResponse = await _dio.get('projects');
      final tasksResponse = await _dio.get('tasks');

      usersCount = usersResponse.data.length;
      projectsCount = projectsResponse.data.length;
      tasksCount = tasksResponse.data.length;

      emit(DashboardLoaded());
    } catch (e) {
      emit(DashboardError(errormessage: e.toString()));
    }
  }
}
