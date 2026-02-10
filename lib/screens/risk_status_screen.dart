import 'package:flutter/material.dart';

class RiskStatusScreen extends StatelessWidget {
  final String studentName;
  final double attendancePercentage;
  final double assignmentCompletionPercentage;
  final double averageScorePercentage;

  const RiskStatusScreen({
    super.key,
    required this.studentName,
    required this.attendancePercentage,
    required this.assignmentCompletionPercentage,
    required this.averageScorePercentage,
  });

  String _riskLabel() {
    if (attendancePercentage >= 75) {
      return "Safe";
    } else if (attendancePercentage >= 60) {
      return "Warning";
    } else {
      return "At Risk";
    }
  }

  Color _riskColor(double value) {
    if (value >= 75) {
      return Colors.red;
    } else if (value >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F44), // ALU dark navy
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F44),
        elevation: 0,
        title: const Text("Your Risk Status"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "Hello $studentName",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _riskLabel(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: 30),

            // Stats cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatCard(
                  value: "${attendancePercentage.toInt()}%",
                  label: "Attendance",
                  color: Colors.red,
                ),
                _StatCard(
                  value: "${assignmentCompletionPercentage.toInt()}%",
                  label: "Assignment to\nSubmit",
                  color: Colors.amber,
                ),
                _StatCard(
                  value: "${averageScorePercentage.toInt()}%",
                  label: "Average\nScore",
                  color: Colors.red,
                ),
              ],
            ),

            const Spacer(),

            // Get Help Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Placeholder for future help action
                },
                child: const Text(
                  "Get Help",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable stat card widget
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
