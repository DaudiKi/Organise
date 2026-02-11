
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assignment.dart';
import '../../providers/assignment_provider.dart';
import '../../constants/colours.dart';

class AddAssignmentScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  const AddAssignmentScreen({super.key, required this.courseId, required this.courseName});

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _priority = 'Medium';
  bool _isLoading = false;

  Future<void> _saveAssignment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final newAssignment = Assignment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: widget.courseId,
        courseName: widget.courseName, // Redundant but kept for model compatibility
        title: _titleController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );

      await context.read<AssignmentProvider>().addAssignment(newAssignment);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment Added!')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryDark,
      appBar: AppBar(title: const Text('Add Assignment'), backgroundColor: kSurfaceDark),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', filled: true, fillColor: Colors.white),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              ListTile(
                title: const Text('Due Date', style: TextStyle(color: Colors.white)),
                subtitle: Text(_dueDate.toString().split(' ')[0], style: const TextStyle(color: kTextSecondary)),
                trailing: const Icon(Icons.calendar_today, color: kAccentGold),
                tileColor: kSurfaceDark,
                onTap: () async {
                   final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority', filled: true, fillColor: Colors.white),
                items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAssignment,
                  style: ElevatedButton.styleFrom(backgroundColor: kAccentGold, foregroundColor: kPrimaryDark),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Post Assignment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
