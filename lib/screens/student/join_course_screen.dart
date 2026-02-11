
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/enrollment_provider.dart';
import '../../providers/user_provider.dart';
import '../../constants/colours.dart';

class JoinCourseScreen extends StatefulWidget {
  const JoinCourseScreen({super.key});

  @override
  State<JoinCourseScreen> createState() => _JoinCourseScreenState();
}

class _JoinCourseScreenState extends State<JoinCourseScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _joinCourse() async {
    final code = _searchController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final user = context.read<UserProvider>().user;
      if (user == null) throw Exception("User not found");

      // 1. Find the course
      final courses = context.read<CourseProvider>().courses;
      final course = courses.cast<dynamic>().firstWhere(
            (c) => c.code.toLowerCase() == code.toLowerCase(),
            orElse: () => null,
          );

      if (course == null) {
        setState(() => _message = 'Course not found with code: $code');
        return;
      }

      // 2. Enroll
      await context.read<EnrollmentProvider>().enroll(user.id, course.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${course.title}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _message = 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryDark,
      appBar: AppBar(
        title: const Text('Join Course'),
        backgroundColor: kSurfaceDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter the Course Code provided by your lecturer to join.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Course Code (e.g. CSE101)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _message,
                style: const TextStyle(color: kErrorColor),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _joinCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGold,
                  foregroundColor: kPrimaryDark,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Join Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
