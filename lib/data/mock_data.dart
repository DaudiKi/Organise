import '../models/assignment.dart';
import '../models/session.dart';

class MockDataProvider {
  // Sample assignments
  static final List<Assignment> assignments = [
    Assignment(
      id: '1',
      title: 'Formative_Assignment_1',
      dueDate: DateTime(2026, 2, 10, 23, 59),
      courseName: 'Mobile Application Development Assignment',
      priority: 'High',
    ),
    Assignment(
      id: '2',
      title: 'Quiz 1',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      courseName: 'Mobile Development',
      priority: 'Medium',
    ),
  ];

  // Sample sessions
  static final List<Session> sessions = [
    Session(
      id: '1',
      title: 'Mobile Application Development - C1',
      date: DateTime(2026, 2, 10),
      startTime: '12:00',
      endTime: '13:30',
      location: 'Room 101', // Assumed location
      sessionType: SessionType.classSession,
      wasAttended: true,
    ),
  ];

  // Get today's sessions
  static List<Session> getTodaysSessions() {
    return sessions.where((session) => session.isToday()).toList();
  }

  // Get assignments due within 7 days
  static List<Assignment> getUpcomingAssignments() {
    return assignments.where((assignment) => assignment.isDueWithinWeek()).toList();
  }

  // Get pending assignments count
  static int getPendingAssignmentsCount() {
    return assignments.where((assignment) => !assignment.isCompleted).length;
  }

  // Calculate attendance percentage
  static double getAttendancePercentage() {
    final attendedSessions = sessions.where((s) => s.wasAttended == true).length;
    final recordedSessions = sessions.where((s) => s.wasAttended != null).length;
    
    if (recordedSessions == 0) return 100.0;
    return (attendedSessions / recordedSessions) * 100;
  }

  // Get academic week number
  static int getAcademicWeek() {
    return 6;
  }
}
