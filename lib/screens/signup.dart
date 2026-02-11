import 'package:flutter/material.dart';

import '../constants/colours.dart';

import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../widgets/form_container_widget.dart';

/// Student Sign-Up Screen
/// Enables university students to create accounts and register for courses
/// through a streamlined mobile-first interface with dark blue background
class StudentSignUpScreen extends StatefulWidget {
  const StudentSignUpScreen({super.key});

  @override
  State<StudentSignUpScreen> createState() => _StudentSignUpScreenState();
}

class _StudentSignUpScreenState extends State<StudentSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;

  // Selected courses tracking
  final Set<String> _selectedCourses = {};

  // Available courses
  final List<String> _availableCourses = [
    'Introduction to Linux and in Ionic',
    'Introduction to Python Programming',
    'Front End Web Development',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Validates university email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your university email';
    }

    // Basic email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // University domain validation (alustudent.com or .edu domain)
    if (!value.toLowerCase().contains('alustudent.com') &&
        !value.toLowerCase().contains('.edu')) {
      return 'Please use your university email (alustudent.com or .edu)';
    }

    return null;
  }

  /// Handles course selection toggle
  void _toggleCourseSelection(String course) {
    setState(() {
      if (_selectedCourses.contains(course)) {
        _selectedCourses.remove(course);
      } else {
        _selectedCourses.add(course);
      }
    });
  }

  /// Handles form submission
  Future<void> _handleSignUp() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if at least one course is selected
    if (_selectedCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one course'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<UserProvider>().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole,
        _nameController.text.trim(),
      );

      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
         // Navigate based on role
         final userProvider = context.read<UserProvider>();
         if (userProvider.isLecturer) {
             Navigator.of(context).pushReplacementNamed('/lecturer-dashboard');
         } else {
             Navigator.of(context).pushReplacementNamed('/dashboard');
         }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully! Enrolled in ${_selectedCourses.length} course(s)',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to dashboard after 1.5 seconds
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
         final userProvider = context.read<UserProvider>();
         if (userProvider.isLecturer) {
             Navigator.of(context).pushReplacementNamed('/lecturer-dashboard');
         } else {
             Navigator.of(context).pushReplacementNamed('/dashboard');
         }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kPrimaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Logo Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: kSurfaceDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school,
                      color: kAccentGold,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Student Sign-Up',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                // Form Container with Course Selection Inside
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role Selection
                DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'I am a...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (UserRole? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                 // Password Field
                TextFormField(
                  controller: _passwordController,
                   obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                FormContainerWidget(
                  formKey: _formKey,
                  emailController: _emailController,
                  validateEmail: _validateEmail,
                  availableCourses: _availableCourses,
                  selectedCourses: _selectedCourses,
                  onCourseToggle: _toggleCourseSelection,
                ),

                const SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentGold,
                      foregroundColor: kPrimaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kPrimaryDark,
                              ),
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: kPrimaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
