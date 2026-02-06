import 'package:flutter/material.dart';

class Announcement {
  final String title;
  final String description;
  final String date;
  final String type;

  Announcement({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });
}

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final List<Announcement> _announcements = [
    Announcement(
      title: "Reminder: Project Deadlines Extended",
      description:
          "Because we good humans, we have decide extended the project deadlines by 2 days. Make sure to submit on time!",
      date: "Feb 20",
      type: "Reminder",
    ),
    Announcement(
      title: "Upcoming Industry Talk",
      description: "Building Apps with Loveable.",
      date: "Feb 18",
      type: "Event",
    ),
    Announcement(
      title: "Update for All Students",
      description: "Valentines is coming. Grab lunch with your loved ones.",
      date: "Feb 14",
      type: "Update",
    ),
    Announcement(
      title: "Office Hours strictly from 7 am to 4 PM",
      description: "Please note that office hours will be strictly from 7 am to 4 PM starting next week. Plan accordingly.",
      date: "Feb 10",
      type: "Update",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: const Color(0xFF0A1733),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF0A1733),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _announcements.length,
          itemBuilder: (context, index) {
            final ann = _announcements[index];
            Color badgeColor = Colors.greenAccent;
            if (ann.type == "Reminder") badgeColor = Colors.orangeAccent;
            if (ann.type == "Event") badgeColor = Colors.blueAccent;

            return Card(
              color: Colors.white.withOpacity(0.08),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ann.type,
                    style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  ann.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(ann.description, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(ann.date, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Opened: ${ann.title}")),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}