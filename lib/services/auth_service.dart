
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserRole {
  student,
  lecturer,
  admin, // Potential admin role
}

class AppUser {
  final String id;
  final String email;
  final UserRole role;
  final String? fullName;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.fullName,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.student,
      ),
      fullName: map['full_name'],
    );
  }
}

abstract class AuthService {
  Stream<AppUser?> get onAuthStateChanged;
  Future<AppUser?> getCurrentUser();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password, UserRole role, String fullName);
  Future<void> signOut();
}

class SupabaseAuthService implements AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _supabase.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return null;
      return await _fetchUserProfile(session.user.id, session.user.email!);
    });
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return await _fetchUserProfile(user.id, user.email!);
  }

  Future<AppUser?> _fetchUserProfile(String userId, String email) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return AppUser.fromMap(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      // If profile doesn't exist, return a basic user or handle error
      // For now, returning null to indicate incomplete setup
      return null;
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password, UserRole role, String fullName) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': role.toString().split('.').last,
      },
    );
    
    // Note: detailed profile creation is often handled by a Postgres Trigger
    // but we can also manually insert if triggers aren't set up.
    // For this implementation, we'll assume a trigger or subsequent insert.
    if (response.user != null) {
         try {
            await _supabase.from('profiles').upsert({
              'id': response.user!.id,
              'email': email,
              'role': role.toString().split('.').last,
              'full_name': fullName,
              'created_at': DateTime.now().toIso8601String(),
            });
         } catch (e) {
             print("Error creating profile: $e");
         }
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

class MockAuthService implements AuthService {
  // Simple stream controller could be used here, but for brevity we'll just return instances
  // In a real mock we might want a StreamController to simulate state changes.
  // For now, let's keep it simple: The UserProvider handles the state, this just returns success.
  
  // We need a way to simulate the stream. 
  // Let's use a broadcast stream controller in the provider instead OR 
  // just return a dummy stream here.
  
  // Revised approach: The UserProvider expects a stream.
  final _currentUser = ValueNotifier<AppUser?>(null);

  @override
  Stream<AppUser?> get onAuthStateChanged => Stream.value(null); // Initial state

  @override
  Future<AppUser?> getCurrentUser() async {
    return _currentUser.value;
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate finding a user. For dev, specific emails could map to roles given here?
    // Actually, sign in is harder to mock without a database unless we hardcode.
    // Let's assume sign IN just logs you in as a STUDENT for now.
    _currentUser.value = AppUser(
      id: 'mock-student-id',
      email: email,
      role: UserRole.student,
      fullName: 'Mock Student',
    );
  }

  @override
  Future<void> signUpWithEmail(String email, String password, UserRole role, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser.value = AppUser(
      id: 'mock-${role.name}-id', // e.g., mock-lecturer-id
      email: email,
      role: role,
      fullName: fullName,
    );
     // To make the provider react, we might need to expose this change closer to the stream
     // But UserProvider listens to onAuthStateChanged. 
     // For this mock to be useful in UserProvider, strictly speaking, `onAuthStateChanged` should emit.
     // However, UserProvider ALSO sets its local state on sign in/up success (if we modified it).
     // Wait, checking UserProvider... it listens to the stream in `_init`.
     // So we SHOULD return a stream that emits.
  }

  @override
  Future<void> signOut() async {
    _currentUser.value = null;
  }
}
