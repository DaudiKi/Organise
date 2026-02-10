import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../data/mock_data.dart';
import 'edit_assignment_screen.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  late Assignment _assignment;

  @override
  void initState() {
    super.initState();
    _assignment = widget.assignment;
  }

  Color _getPriorityColor() {
    switch (_assignment.priority) {
      case 'High':
        return const Color(0xFFC41E3A);
      case 'Medium':
        return const Color(0xFFF5A623);
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _deleteAssignment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text(
          'Delete Assignment',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this assignment?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              MockDataProvider.deleteAssignment(_assignment.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to assignments list
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC41E3A),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editAssignment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAssignmentScreen(assignment: _assignment),
      ),
    );

    if (result == true) {
      // Refresh the assignment data
      final updatedAssignment = MockDataProvider.assignments
          .firstWhere((a) => a.id == _assignment.id);
      setState(() {
        _assignment = updatedAssignment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final daysUntilDue = _assignment.dueDate.difference(DateTime.now()).inDays;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text(
          'Assignment Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editAssignment,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAssignment,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getPriorityColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getPriorityColor(),
                  width: 1,
                ),
              ),
              child: Text(
                '${_assignment.priority} Priority',
                style: TextStyle(
                  color: _getPriorityColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              _assignment.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Course Name
            Text(
              _assignment.courseName,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Due Date Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Due Date',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormat.format(_assignment.dueDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    daysUntilDue < 0
                        ? 'Overdue by ${-daysUntilDue} days'
                        : daysUntilDue == 0
                            ? 'Due today'
                            : 'Due in $daysUntilDue days',
                    style: TextStyle(
                      color: daysUntilDue < 0
                          ? const Color(0xFFC41E3A)
                          : daysUntilDue <= 2
                              ? const Color(0xFFF5A623)
                              : Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _assignment.isCompleted
                        ? Icons.check_circle
                        : Icons.pending,
                    color: _assignment.isCompleted
                        ? Colors.green
                        : const Color(0xFFF5A623),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _assignment.isCompleted ? 'Completed' : 'Pending',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
