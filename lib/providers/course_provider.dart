
import 'package:flutter/foundation.dart';
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  final List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  // Get courses by lecturer ID
  List<Course> getCoursesByLecturer(String lecturerId) {
    return _courses.where((course) => course.lecturerId == lecturerId).toList();
  }

  Future<void> addCourse(String code, String title, String description, String lecturerId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final newCourse = Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
      title: title,
      description: description,
      lecturerId: lecturerId,
    );

    _courses.add(newCourse);
    _isLoading = false;
    notifyListeners();
  }
}
