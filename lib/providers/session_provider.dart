
import 'package:flutter/foundation.dart';
import '../models/session.dart';

class SessionProvider with ChangeNotifier {
  final List<Session> _sessions = [];
  bool _isLoading = false;

  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;

  List<Session> getSessionsByCourse(String courseId) {
    return _sessions.where((s) => s.courseId == courseId).toList();
  }

  // For student dashboard (schedule view)
  List<Session> getSessionsByCourses(List<String> courseIds) {
     return _sessions.where((s) => courseIds.contains(s.courseId)).toList();
  }

  Future<void> addSession(Session session) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _sessions.add(session);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSession(Session updatedSession) async {
    final index = _sessions.indexWhere((s) => s.id == updatedSession.id);
    if (index != -1) {
      _sessions[index] = updatedSession;
      notifyListeners();
    }
  }
}
