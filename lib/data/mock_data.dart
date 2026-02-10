import '../models/assignment.dart';
import '../models/session.dart';

class MockDataProvider {
  // Mutable assignments list (in-memory persistence)
  static final List<Assignment> _assignments = [
    Assignment(
      id: '1',
      title: 'Formative_Assignment_1',
      dueDate: DateTime(2026, 2, 10, 23, 59),
      courseName: 'Mobile Application Development Assignment',
      priority: 'High',
    ),
  ];

  // Getter that returns sorted assignments by due date
  static List<Assignment> get assignments {
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return _assignments;
  }

  // Add a new assignment
  static void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
  }

  // Update an existing assignment
  static void updateAssignment(Assignment updatedAssignment) {
    final index = _assignments.indexWhere((a) => a.id == updatedAssignment.id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
    }
  }

  // Delete an assignment
  static void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
  }

  // Get assignments by priority
  static List<Assignment> getAssignmentsByPriority(String priority) {
    return assignments.where((a) => a.priority == priority).toList();
  }

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

  // Get student name
  static String getStudentName() {
    return 'Student';
  }

  // Calculate assignment completion percentage
  static double getAssignmentCompletionPercentage() {
    if (assignments.isEmpty) return 100.0;
    final completedAssignments = assignments.where((a) => a.isCompleted).length;
    return (completedAssignments / assignments.length) * 100;
  }

  // Get average score percentage
  static double getAverageScorePercentage() {
    // Mock average score - in a real app, this would be calculated from actual grades
    return 78.5;
  }
}
