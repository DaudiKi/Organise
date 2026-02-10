import 'package:flutter/material.dart';

import '../constants/colours.dart';

///container housing email input field and course selection
class FormContainerWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? Function(String?) validateEmail;
  final List<String> availableCourses;
  final Set<String> selectedCourses;
  final Function(String) onCourseToggle;

  const FormContainerWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.validateEmail,
    required this.availableCourses,
    required this.selectedCourses,
    required this.onCourseToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Student Sign-Up',
              style: theme.textTheme.titleLarge?.copyWith(
                color: kTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // University Email Field
            Text(
              'University Email',
              style: theme.textTheme.titleSmall?.copyWith(
                color: kTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              style: const TextStyle(color: kTextPrimary),
              decoration: InputDecoration(
                hintText: 'your.email@alustudent.com',
                hintStyle: const TextStyle(color: kTextTertiary),
                prefixIcon: Icon(
                  Icons.email,
                  color: kTextTertiary,
                ),
                filled: true,
                fillColor: kPrimaryDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.15), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.15), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: kAccentGold,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: theme.colorScheme.error, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: theme.colorScheme.error, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Select Your Courses Section
            Text(
              'Select Your Courses',
              style: theme.textTheme.titleSmall?.copyWith(
                color: kTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Course Buttons
            ...availableCourses.map((course) {
              final isSelected = selectedCourses.contains(course);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => onCourseToggle(course),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kAccentGold.withOpacity(0.18)
                          : kPrimaryDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? kAccentGold
                            : Colors.white.withOpacity(0.10),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      course,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? kAccentGold : kTextPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
