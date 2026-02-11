class Assignment {
  final String id;
  final String courseId;
  final String title;
  final DateTime dueDate;
  final String courseName;
  final String priority; // 'High', 'Medium', 'Low'
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.dueDate,
    required this.courseName,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  // Check if assignment is due within the next 7 days
  bool isDueWithinWeek() {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays >= 0 && difference.inDays <= 7;
  }

  // Check if assignment is due today
  bool isDueToday() {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }
}
