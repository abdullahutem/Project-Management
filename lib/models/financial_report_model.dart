import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/models/project_summary_model.dart';
import 'package:cmp/models/user_summary_model.dart';

class FinancialReportModel {
  final double totalHours;
  final double totalCost;
  final int entriesCount;
  final ProjectSummaryModel projectSummary;
  final UserSummaryModel userSummary;

  FinancialReportModel({
    required this.totalHours,
    required this.totalCost,
    required this.entriesCount,
    required this.projectSummary,
    required this.userSummary,
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    return FinancialReportModel(
      totalHours: (json[ApiKeys.total_hours] as num).toDouble(),
      totalCost: (json[ApiKeys.total_cost] as num).toDouble(),
      entriesCount: json[ApiKeys.replies_count] as int? ?? 0,
      projectSummary: ProjectSummaryModel.fromJson(json['project_summary']),
      userSummary: UserSummaryModel.fromJson(json['user_summary']),
    );
  }
}
