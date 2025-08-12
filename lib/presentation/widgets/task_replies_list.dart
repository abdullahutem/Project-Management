import 'package:cmp/models/task_replies_model.dart';
import 'package:flutter/material.dart';

class TaskRepliesList extends StatelessWidget {
  final List<TaskRepliesModel> replies;

  const TaskRepliesList({super.key, required this.replies});

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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (context, index) {
        final reply = replies[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الرقم: ${reply.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Chip(
                      label: Text(
                        reply.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      // backgroundColor: reply.status == 'Submitted'
                      //     ? ColorManager.primaryColor
                      //     : Colors.grey,
                      backgroundColor: _getStatusColor(reply.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Displaying Note
                Text(
                  'الملاحظة:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reply.note,
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  'تاريخ البدء:',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  reply.start_date,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  'تاريخ الانتهاء:',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  reply.end_date,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
