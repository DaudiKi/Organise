
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService;
  AppUser? _user;
  bool _isLoading = true;

  UserProvider(this._authService) {
    _init();
  }

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isLecturer => _user?.role == UserRole.lecturer;

  void _init() {
    _authService.onAuthStateChanged.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmail(email, password);
      // For Mock: Manually update user since stream might not trigger
      if (_authService is MockAuthService) {
        _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, UserRole role, String fullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpWithEmail(email, password, role, fullName);
      // For Mock: Manually update user
      if (_authService is MockAuthService) {
         _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
     await _authService.signOut();
  }
}
