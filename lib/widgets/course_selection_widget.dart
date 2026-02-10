import 'package:flutter/material.dart';

/// Course Selection Widget
/// Displays available courses with simple tap-to-select functionality
class CourseSelectionWidget extends StatelessWidget {
  final List<String> availableCourses;
  final Set<String> selectedCourses;
  final Function(String) onCourseToggle;

  const CourseSelectionWidget({
    super.key,
    required this.availableCourses,
    required this.selectedCourses,
    required this.onCourseToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Select Your Courses',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Course Buttons
        ...availableCourses.map((course) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: InkWell(
              onTap: () => onCourseToggle(course),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a237e),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
