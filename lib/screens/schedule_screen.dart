import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/user_provider.dart';
import '../providers/enrollment_provider.dart';
import '../providers/session_provider.dart';
import '../constants/colours.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().user?.id;
    if (userId == null) return const Center(child: CircularProgressIndicator());

    final enrolledCourseIds = context.watch<EnrollmentProvider>().getEnrolledCourseIds(userId);
    final weeklySessions = context.watch<SessionProvider>().getSessionsByCourses(enrolledCourseIds);
    // Note: This gets ALL sessions for enrolled courses. 
    // Ideally we should filter for "this week" here or in the provider.
    // For now, let's filter to upcoming week logic if compatible with mock data, 
    // or just show all for simplicity as "Weekly Schedule" might imply a view.
    // The original checks `isInCurrentWeek`.
    final filteredSessions = weeklySessions.where((s) => s.isInCurrentWeek()).toList();
    
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        backgroundColor: AppColours.cardBackground,
        title: const Text(
          'Weekly Schedule',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: filteredSessions.isEmpty
          ? _buildEmptyState()
          : _buildScheduleList(filteredSessions),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: AppColours.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Sessions This Week',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(List<Session> sessions) {
    // Group sessions by date
    Map<String, List<Session>> groupedSessions = {};
    
    for (var session in sessions) {
      final dateKey = _formatDateKey(session.date);
      if (!groupedSessions.containsKey(dateKey)) {
        groupedSessions[dateKey] = [];
      }
      groupedSessions[dateKey]!.add(session);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedSessions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSessions.keys.elementAt(index);
        final dateSessions = groupedSessions[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(dateKey, dateSessions[0].date),
            const SizedBox(height: 8),
            ...dateSessions.map((session) => _buildSessionCard(session)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateKey, DateTime date) {
    final isToday = _isToday(date);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isToday ? AppColours.primary : AppColours.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dateKey,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          if (isToday) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Card(
      color: AppColours.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSessionTypeIcon(session.sessionType),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.sessionTypeDisplay,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 24),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[400], size: 16),
                const SizedBox(width: 6),
                Text(
                  '${session.startTime} - ${session.endTime}',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                const SizedBox(width: 16),
                if (session.location.isNotEmpty) ...[
                  Icon(Icons.location_on, color: Colors.grey[400], size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      session.location,
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            _buildAttendanceToggle(session),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTypeIcon(SessionType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case SessionType.classSession:
        icon = Icons.school;
        color = Colors.blue;
        break;
      case SessionType.masterySession:
        icon = Icons.emoji_events;
        color = Colors.purple;
        break;
      case SessionType.studyGroup:
        icon = Icons.groups;
        color = Colors.green;
        break;
      case SessionType.pslMeeting:
        icon = Icons.meeting_room;
        color = Colors.orange;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildAttendanceToggle(Session session) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColours.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Attendance:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _buildAttendanceButton(
                label: 'Present',
                isSelected: session.wasAttended == true,
                color: Colors.green,
                onTap: () => _updateAttendance(session.id, true),
              ),
              const SizedBox(width: 8),
              _buildAttendanceButton(
                label: 'Absent',
                isSelected: session.wasAttended == false,
                color: Colors.red,
                onTap: () => _updateAttendance(session.id, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey[600]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatDateKey(DateTime date) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _updateAttendance(String sessionId, bool wasAttended) {
    final session = context.read<SessionProvider>().sessions.firstWhere((s) => s.id == sessionId);
    final updatedSession = session.copyWith(wasAttended: wasAttended);
    context.read<SessionProvider>().updateSession(updatedSession);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance marked as ${wasAttended ? "Present" : "Absent"}'),
        backgroundColor: wasAttended ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
