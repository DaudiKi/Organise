
import 'package:flutter/foundation.dart';
import '../models/assignment.dart';

class AssignmentProvider with ChangeNotifier {
  final List<Assignment> _assignments = [];
  bool _isLoading = false;

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;

  List<Assignment> getAssignmentsByCourse(String courseId) {
    return _assignments.where((a) => a.courseId == courseId).toList();
  }
  
  // For student dashboard (all enrolled courses)
  List<Assignment> getAssignmentsByCourses(List<String> courseIds) {
    return _assignments.where((a) => courseIds.contains(a.courseId)).toList();
  }

  Future<void> addAssignment(Assignment assignment) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _assignments.add(assignment);
    _isLoading = false;
    notifyListeners();
  }
}
