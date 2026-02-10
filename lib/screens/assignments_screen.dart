import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/assignment_card_widget.dart';
import 'assignment_details_screen.dart';
import 'edit_assignment_screen.dart';

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

  void _createAssignment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditAssignmentScreen(),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  Widget _buildAssignmentsList(List<dynamic> assignments) {
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
    final allAssignments = MockDataProvider.assignments;
    final highPriorityAssignments =
        MockDataProvider.getAssignmentsByPriority('High');
    final mediumPriorityAssignments =
        MockDataProvider.getAssignmentsByPriority('Medium');
    final lowPriorityAssignments =
        MockDataProvider.getAssignmentsByPriority('Low');

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
                    TextButton(
                        onPressed: _createAssignment,
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "Create Group Assignment",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
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
                    TextButton(
                        onPressed: _createAssignment,
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "Create Group Assignment",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
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
                    TextButton(
                        onPressed: _createAssignment,
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "Create Group Assignment",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
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
                    TextButton(
                        onPressed: _createAssignment,
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          "Create Group Assignment",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
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
