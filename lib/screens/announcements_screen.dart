import 'package:flutter/material.dart';
import '../constants/colours.dart'; 

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

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  final List<Announcement> _announcements = [
    Announcement(
      title: "Reminder: Project Deadlines Extended",
      description:
          "Because we good humans, we decided to extend the project deadlines by 2 days. Make sure to submit on time!",
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
      title: "Office Hours are strictly from 7 am to 4 PM",
      description:
          "Please note that office hours will be strictly from 7 am to 4 PM starting next week. Plan accordingly.",
      date: "Feb 10",
      type: "Update",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1)); // simulate refresh
          // You can later add real logic here (e.g. reload from storage)
        },
        color: kAccentGold,
        backgroundColor: kSurfaceDark,
        child: _announcements.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 80,
                      color: kTextTertiary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No announcements yet",
                      style: TextStyle(
                        fontSize: 20,
                        color: kTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Check back later for university updates",
                      style: TextStyle(color: kTextTertiary),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _announcements.length,
                itemBuilder: (context, index) {
                  final ann = _announcements[index];

                  Color badgeColor = kUpdateColor;
                  switch (ann.type) {
                    case "Reminder":
                      badgeColor = kReminderColor;
                      break;
                    case "Event":
                      badgeColor = kEventColor;
                      break;
                    case "Update":
                      badgeColor = kUpdateColor;
                      break;
                  }

                  return Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.3),
                    color: kSurfaceDark,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ann.type,
                          style: TextStyle(
                            color: badgeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(
                        ann.title,
                        style: const TextStyle(
                          color: kTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            ann.description,
                            style: const TextStyle(color: kTextSecondary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ann.date,
                            style: const TextStyle(
                              color: kTextTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: kTextTertiary,
                        size: 28,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: kSurfaceDark,
                            title: Text(
                              ann.title,
                              style: const TextStyle(
                                color: kTextPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              ann.description,
                              style: const TextStyle(color: kTextSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(color: kAccentGold),
                                ),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
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