import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/controller/statistics/cubit/statistics_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/presentation/widgets/dashboard_card.dart';
import 'package:cmp/presentation/widgets/side_menu.dart';
import 'package:cmp/repo/statistics_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final statisticsRepo = StatisticsRepo(api: DioConsumer(dio: Dio()));
  final role = CacheHelper().getDataString(key: ApiKeys.role);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatisticsCubit(statisticsRepo)..getStatisticsReport(),
      child: Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: const Text(
            'الرئيسية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 6,
          shadowColor: ColorManager.primaryColor.withOpacity(0.6),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade100, Colors.white],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك!',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'نظرة سريعة على بياناتك',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: BlocBuilder<StatisticsCubit, StatisticsState>(
                    builder: (context, state) {
                      if (state is LoadingStatistics) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ErrorStatistics) {
                        // Display an error message to the user
                        return Center(child: Text('Error: ${state.error}'));
                      } else if (state is LoadedStatistics) {
                        final model = state.satisticsModel;
                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio: 0.9,
                          children: [
                            DashboardCard(
                              icon: Icons.business_center_outlined,
                              label: 'المشاريع',
                              count: model.projects_count,
                              baseColor: Colors.greenAccent.shade700,
                              function: () {},
                            ),
                            DashboardCard(
                              icon: Icons.checklist_rtl_outlined,
                              label: 'المهام',
                              count: model.tasks_count,
                              baseColor: Colors.orange.shade700,
                              function: () {},
                            ),
                            role == 'admin'
                                ? DashboardCard(
                                    icon: Icons.groups_2_outlined,
                                    label: 'الموظفين',
                                    count: model.users_count,
                                    baseColor: Colors.blue.shade700,
                                    function: () {},
                                  )
                                : const SizedBox(),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
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
