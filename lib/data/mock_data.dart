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

  // Mutable sessions list (in-memory persistence)
  static final List<Session> _sessions = [
    Session(
      id: '1',
      title: 'Mobile Application Development - C1',
      date: DateTime(2026, 2, 10),
      startTime: '12:00',
      endTime: '13:30',
      location: 'Room 101',
      sessionType: SessionType.classSession,
      wasAttended: true,
    ),
    Session(
      id: '2',
      title: 'Data Structures & Algorithms',
      date: DateTime(2026, 2, 11),
      startTime: '09:00',
      endTime: '10:30',
      location: 'Room 102',
      sessionType: SessionType.classSession,
      wasAttended: null,
    ),
    Session(
      id: '3',
      title: 'Mobile Dev Study Group',
      date: DateTime(2026, 2, 12),
      startTime: '14:00',
      endTime: '16:00',
      location: 'Library',
      sessionType: SessionType.studyGroup,
      wasAttended: null,
    ),
  ];

  // Getter that returns sorted sessions by date
  static List<Session> get sessions {
    _sessions.sort((a, b) => a.date.compareTo(b.date));
    return _sessions;
  }

  // Add a new session
  static void addSession(Session session) {
    _sessions.add(session);
  }

  // Update an existing session
  static void updateSession(Session updatedSession) {
    final index = _sessions.indexWhere((s) => s.id == updatedSession.id);
    if (index != -1) {
      _sessions[index] = updatedSession;
    }
  }

  // Delete a session
  static void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
  }

  // Get sessions for current week
  static List<Session> getWeeklySessions() {
    return sessions.where((session) => session.isInCurrentWeek()).toList();
  }

  // Update session attendance
  static void updateSessionAttendance(String id, bool wasAttended) {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(wasAttended: wasAttended);
    }
  }

  // Generate unique ID for new session
  static String generateSessionId() {
    if (_sessions.isEmpty) return '1';
    final maxId = _sessions
        .map((s) => int.tryParse(s.id) ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return (maxId + 1).toString();
  }

  // Sample sessions (deprecated - use _sessions instead)
  @Deprecated('Use sessions getter instead')
  static final List<Session> deprecatedSessions = _sessions;

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
