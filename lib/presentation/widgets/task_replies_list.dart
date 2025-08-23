import 'package:cmp/models/task_replies_model.dart';
import 'package:flutter/material.dart';

class TaskRepliesList extends StatelessWidget {
  final void Function(dynamic) changeToRejected;
  final void Function(dynamic) changeToApproved;
  final void Function(dynamic) changeToSubmitted;
  final List<TaskRepliesModel> replies;

  const TaskRepliesList({
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
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            reply.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: _getStatusColor(reply.status),
                        ),
                        // Added PopupMenuButton here
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Rejected') {
                              changeToRejected(index);
                            } else if (value == 'Approved') {
                              changeToApproved(index);
                            } else if (value == 'Submitted') {
                              changeToSubmitted(index);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            // If the status is Approved, show options to change to Rejected or Submitted
                            if (reply.status == "Approved") ...[
                              PopupMenuItem<String>(
                                value: 'Rejected',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'مرفوض',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // Using a more suitable icon for "Rejected"
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Submitted',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'قيد الانتظار',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // Correct icon for "Submitted"
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // If the status is Submitted, show options to change to Approved or Rejected
                            if (reply.status == "Submitted") ...[
                              PopupMenuItem<String>(
                                value: 'Approved',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'موافقة',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // Using a more suitable icon for "Approved"
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Rejected',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'مرفوض',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // Correct icon for "Rejected"
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // If the status is Rejected, show options to change to Approved or Submitted
                            if (reply.status == "Rejected") ...[
                              PopupMenuItem<String>(
                                value: 'Approved',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'موافقة',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    // Correct icon for "Approved"
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Submitted',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'مسلم',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Displaying Note
                const Text(
                  'الملاحظة:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  reply.note,
                  softWrap: true,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                const Text(
                  'تاريخ البدء:',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  reply.start_date,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                const Text(
                  'تاريخ الانتهاء:',
                  style: TextStyle(color: Colors.black, fontSize: 12),
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
