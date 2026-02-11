enum SessionType {
  classSession,
  masterySession,
  studyGroup,
  pslMeeting,
}

class Session {
  final String id;
  final String courseId;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final SessionType sessionType;
  final bool? wasAttended; // null = not yet recorded

  Session({
    required this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.sessionType,
    this.wasAttended,
  });

  // Check if session is today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if session is in current week
  bool isInCurrentWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Get session type display name
  String get sessionTypeDisplay {
    switch (sessionType) {
      case SessionType.classSession:
        return 'Class';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }

  // Get session type from string
  static SessionType sessionTypeFromString(String type) {
    switch (type) {
      case 'Class':
        return SessionType.classSession;
      case 'Mastery Session':
        return SessionType.masterySession;
      case 'Study Group':
        return SessionType.studyGroup;
      case 'PSL Meeting':
        return SessionType.pslMeeting;
      default:
        return SessionType.classSession;
    }
  }

  // Copy with method for updating
  Session copyWith({
    String? id,
    String? courseId,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    SessionType? sessionType,
    bool? wasAttended,
  }) {
    return Session(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      wasAttended: wasAttended ?? this.wasAttended,
    );
  }
}
