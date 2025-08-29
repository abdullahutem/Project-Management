import 'package:cmp/models/task_replies_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskRepliesCard extends StatelessWidget {
  final VoidCallback changeToRejected;
  final VoidCallback changeToApproved;
  final VoidCallback changeToSubmitted;
  final TaskRepliesModel replies;

  const TaskRepliesCard({
    super.key,
    required this.replies,
    required this.changeToRejected,
    required this.changeToApproved,
    required this.changeToSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    Color _getStatusColor(String status) {
      switch (status) {
        case 'Submitted':
          return Colors.green;
        case 'Rejected':
          return Colors.red;
        case 'Approved':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Color(0xff038187), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(replies.note, replies.status),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey, height: 1),
            _buildSection(
              title: 'البيانات الأساسية',
              children: [
                SizedBox(
                  height: 131,
                  width: 120,
                  child: _buildDetailRow(
                    label: 'الحالة',
                    value: replies.status,
                    assetName: "assets/svgs/ActiveTasks.svg",
                    color: _getStatusColor(replies.status),
                  ),
                ),
                const SizedBox(width: 5),
                _buildDetailRow(
                  label: 'تاريخ البدء',
                  value: replies.start_date,
                  assetName: "assets/svgs/StartDate.svg",
                  color: Colors.black87,
                ),
                const SizedBox(width: 5),
                _buildDetailRow(
                  label: 'تاريخ الانتهاء',
                  value: replies.end_date,
                  assetName: "assets/svgs/EndDate.svg",
                  color: Colors.black87,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String status) {
    return Row(
      children: [
        const Icon(Icons.task_outlined, color: Color(0xff038187), size: 24),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff038187),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Rejected') {
              changeToRejected();
            } else if (value == 'Approved') {
              changeToApproved();
            } else if (value == 'Submitted') {
              changeToSubmitted();
            }
          },
          itemBuilder: (BuildContext context) => [
            if (status == "Approved") ...[
              PopupMenuItem<String>(
                value: 'Rejected',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مرفوض', style: TextStyle(color: Colors.black)),
                    // Using a more suitable icon for "Rejected"
                    Icon(Icons.cancel_outlined, color: Colors.red),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Submitted',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مسلم', style: TextStyle(color: Colors.black)),
                    // Correct icon for "Submitted"
                    Icon(Icons.access_time, color: Colors.orange),
                  ],
                ),
              ),
            ],
            // If the status is Submitted, show options to change to Approved or Rejected
            if (status == "Submitted") ...[
              PopupMenuItem<String>(
                value: 'Approved',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('موافقة', style: TextStyle(color: Colors.black)),
                    // Using a more suitable icon for "Approved"
                    Icon(Icons.check_circle_outline, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Rejected',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مرفوض', style: TextStyle(color: Colors.black)),
                    Icon(Icons.cancel_outlined, color: Colors.red),
                  ],
                ),
              ),
            ],
            if (status == "Rejected") ...[
              PopupMenuItem<String>(
                value: 'Approved',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('موافقة', style: TextStyle(color: Colors.black)),
                    Icon(Icons.check_circle_outline, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Submitted',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('مسلم', style: TextStyle(color: Colors.black)),
                    Icon(Icons.access_time, color: Colors.orange),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff038187),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey, height: 3),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required String assetName,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            SvgPicture.asset(assetName, width: 40, height: 40),
            const SizedBox(height: 7),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
