
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/session_provider.dart';
import '../../providers/assignment_provider.dart';
import '../../constants/colours.dart';
import 'add_session_screen.dart';
import 'add_assignment_screen.dart';

class ManageCourseScreen extends StatelessWidget {
  final Course course;

  const ManageCourseScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryDark,
        appBar: AppBar(
          backgroundColor: kSurfaceDark,
          title: Text(course.code),
          bottom: const TabBar(
            indicatorColor: kAccentGold,
            labelColor: kAccentGold,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Schedule'),
              Tab(text: 'Assignments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
             _ScheduleTab(courseId: course.id),
             _AssignmentsTab(courseId: course.id, courseName: course.title),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  final String courseId;
  const _ScheduleTab({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Nested Scaffold for FAB
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSessionScreen(courseId: courseId)),
          );
        },
        label: const Text('Add Class'),
        icon: const Icon(Icons.add),
        backgroundColor: kAccentGold,
        foregroundColor: kPrimaryDark,
      ),
      body: Consumer<SessionProvider>(
        builder: (context, provider, child) {
          final sessions = provider.getSessionsByCourse(courseId);
          
          if (sessions.isEmpty) {
            return const Center(child: Text('No sessions yet.', style: TextStyle(color: kTextSecondary)));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                color: kSurfaceDark,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                   title: Text(session.title, style: const TextStyle(color: Colors.white)),
                   subtitle: Text('${session.sessionTypeDisplay} • ${session.startTime}', style: const TextStyle(color: kTextSecondary)),
                   trailing: const Icon(Icons.edit, color: Colors.white70),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AssignmentsTab extends StatelessWidget {
  final String courseId;
  final String courseName;
  const _AssignmentsTab({required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
         onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssignmentScreen(courseId: courseId, courseName: courseName),
            ),
          );
        },
        label: const Text('Add Assignment'),
        icon: const Icon(Icons.assignment_add),
        backgroundColor: kAccentGold,
        foregroundColor: kPrimaryDark,
      ),
      body: Consumer<AssignmentProvider>(
        builder: (context, provider, child) {
          final assignments = provider.getAssignmentsByCourse(courseId);

          if (assignments.isEmpty) {
             return const Center(child: Text('No assignments yet.', style: TextStyle(color: kTextSecondary)));
          }

          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Card(
                color: kSurfaceDark,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                   title: Text(assignment.title, style: const TextStyle(color: Colors.white)),
                   subtitle: Text('Due: ${assignment.dueDate.toString().split(' ')[0]}', style: const TextStyle(color: kTextSecondary)),
                   trailing: Chip(
                     label: Text(assignment.priority),
                     backgroundColor: _getPriorityColor(assignment.priority),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                   ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return kErrorColor;
      case 'medium': return kAccentGold; 
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }
}
