import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/enrollment_provider.dart';
import '../providers/assignment_provider.dart';
import '../models/assignment.dart';
import '../widgets/assignment_card_widget.dart';
import 'assignment_details_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  void _navigateToDetails(assignment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentDetailsScreen(assignment: assignment),
      ),
    );
    // Refresh the screen after returning
    setState(() {});
  }


  Widget _buildAssignmentsList(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No assignments found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: assignments
            .map((assignment) => AssignmentCardWidget(
                  assignment: assignment,
                  onTap: () => _navigateToDetails(assignment),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().user?.id;
    if (userId == null) return const Center(child: CircularProgressIndicator());

    final enrolledCourseIds = context.watch<EnrollmentProvider>().getEnrolledCourseIds(userId);
    final allAssignments = context.watch<AssignmentProvider>().getAssignmentsByCourses(enrolledCourseIds);

    final highPriorityAssignments = allAssignments.where((a) => a.priority == 'High').toList();
    final mediumPriorityAssignments = allAssignments.where((a) => a.priority == 'Medium').toList();
    final lowPriorityAssignments = allAssignments.where((a) => a.priority == 'Low').toList();

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: const Color(0xFF0D1B2A),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1B263B),
              title: const Text(
                'Assignments',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'High Priority'),
                  Tab(text: 'Medium Priority'),
                  Tab(text: 'Low Priority'),
                ],
                indicatorColor: Theme.of(context).colorScheme.secondary,
                labelColor: Colors.white,
                isScrollable: true,
              ),
            ),
            body: TabBarView(children: [
              // All Assignments Tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildAssignmentsList(allAssignments),
                    ),
                  ],
                ),
              ),
              // High Priority Tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildAssignmentsList(highPriorityAssignments),
                    ),
                  ],
                ),
              ),
              // Medium Priority Tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildAssignmentsList(mediumPriorityAssignments),
                    ),
                  ],
                ),
              ),
              // Low Priority Tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildAssignmentsList(lowPriorityAssignments),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
