
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/course_provider.dart';
import '../../constants/colours.dart';
import 'create_course_screen.dart';
import 'manage_course_screen.dart';

class LecturerDashboardScreen extends StatelessWidget {
  const LecturerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: kPrimaryDark,
      appBar: AppBar(
        backgroundColor: kSurfaceDark,
        title: const Text('Lecturer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
               context.read<UserProvider>().signOut();
               Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.fullName ?? "Lecturer"}!',
              style: const TextStyle(color: kTextPrimary, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create New Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentGold,
                foregroundColor: kPrimaryDark,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
                );
              },
            ),
             const SizedBox(height: 20),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                   final myCourses = courseProvider.getCoursesByLecturer(user!.id);
                   
                   if (myCourses.isEmpty) {
                     return const Center(
                       child: Text(
                        'No courses yet. Create one above!',
                        style: TextStyle(color: kTextSecondary),
                      ),
                     );
                   }

                   return ListView.builder(
                     itemCount: myCourses.length,
                     itemBuilder: (context, index) {
                       final course = myCourses[index];
                       return Card(
                         color: kSurfaceDark,
                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         child: ListTile(
                           leading: CircleAvatar(
                             backgroundColor: kAccentGold,
                             child: Text(course.code.substring(0, 1)),
                           ),
                           title: Text(course.title, style: const TextStyle(color: Colors.white)),
                           subtitle: Text(course.code, style: const TextStyle(color: kTextSecondary)),
                           trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                           onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => ManageCourseScreen(course: course),
                               ),
                             );
                           },
                         ),
                       );
                     },
                   );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
