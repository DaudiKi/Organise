
import 'package:flutter/foundation.dart';
import '../models/enrollment.dart';

class EnrollmentProvider with ChangeNotifier {
  final List<Enrollment> _enrollments = [];
  bool _isLoading = false;

  List<Enrollment> get enrollments => _enrollments;
  bool get isLoading => _isLoading;

  List<String> getEnrolledCourseIds(String userId) {
    return _enrollments
        .where((e) => e.userId == userId)
        .map((e) => e.courseId)
        .toList();
  }

  bool isEnrolled(String userId, String courseId) {
    return _enrollments.any((e) => e.userId == userId && e.courseId == courseId);
  }

  Future<void> enroll(String userId, String courseId) async {
    if (isEnrolled(userId, courseId)) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _enrollments.add(Enrollment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      courseId: courseId,
    ));

    _isLoading = false;
    notifyListeners();
  }
}
