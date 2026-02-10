import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/date_header_widget.dart';
import '../widgets/attendance_warning_widget.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/session_card_widget.dart';
import '../widgets/assignment_card_widget.dart';
import 'assignment_details_screen.dart';
import 'risk_status_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todaysSessions = MockDataProvider.getTodaysSessions();
    final upcomingAssignments = MockDataProvider.getUpcomingAssignments();
    final pendingCount = MockDataProvider.getPendingAssignmentsCount();
    final attendancePercentage = MockDataProvider.getAttendancePercentage();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28,
            ),
            tooltip: 'Risk Status',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RiskStatusScreen(
                    studentName: MockDataProvider.getStudentName(),
                    attendancePercentage: attendancePercentage,
                    assignmentCompletionPercentage:
                        MockDataProvider.getAssignmentCompletionPercentage(),
                    averageScorePercentage:
                        MockDataProvider.getAverageScorePercentage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Week Header
              const DateHeaderWidget(),

              // Attendance Warning (if below 75%)
              AttendanceWarningWidget(
                attendancePercentage: attendancePercentage,
              ),

              // Quick Stats Cards
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatsCardWidget(
                        count: '1',
                        label: 'Active\nProjects',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCardWidget(
                        count: '1',
                        label: 'Code\nSectors',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCardWidget(
                        count: '1',
                        label: 'Upcoming\nAgendas',
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatsCardWidget(
                        count: '${attendancePercentage.toStringAsFixed(0)}%',
                        label: 'Attendance',
                        backgroundColor: attendancePercentage < 75
                            ? const Color(0xFFC41E3A)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCardWidget(
                        count: '$pendingCount',
                        label: 'Pending\nAssignments',
                        backgroundColor: const Color(0xFFF5A623),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Today's Classes Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Today's Classes",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sessions List
              if (todaysSessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'No sessions scheduled for today',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: todaysSessions
                        .map((session) => SessionCardWidget(session: session))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 24),

              // Upcoming Assignments Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Assignments Due Within 7 Days',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Assignments List
              if (upcomingAssignments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'No assignments due within the next 7 days',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: upcomingAssignments
                        .map((assignment) => AssignmentCardWidget(
                              assignment: assignment,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssignmentDetailsScreen(
                                      assignment: assignment,
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
