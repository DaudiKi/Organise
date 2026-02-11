
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/session_provider.dart';
import '../../constants/colours.dart';

class AddSessionScreen extends StatefulWidget {
  final String courseId;
  const AddSessionScreen({super.key, required this.courseId});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 30);
  SessionType _sessionType = SessionType.classSession;
  
  bool _isLoading = false;

  Future<void> _saveSession() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final newSession = Session(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: widget.courseId,
        title: _titleController.text.trim(),
        date: _selectedDate,
        startTime: _startTime.format(context),
        endTime: _endTime.format(context),
        location: _locationController.text.trim(),
        sessionType: _sessionType,
      );

      await context.read<SessionProvider>().addSession(newSession);

       if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session Added!')),
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
      appBar: AppBar(title: const Text('Add Session'), backgroundColor: kSurfaceDark),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title (e.g. Week 1 Lecture)', filled: true, fillColor: Colors.white),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Date Picker
              ListTile(
                title: const Text('Date', style: TextStyle(color: Colors.white)),
                subtitle: Text(_selectedDate.toString().split(' ')[0], style: const TextStyle(color: kTextSecondary)),
                trailing: const Icon(Icons.calendar_today, color: kAccentGold),
                tileColor: kSurfaceDark,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 16),
              
              // Time Pickers
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start', style: TextStyle(color: Colors.white)),
                      subtitle: Text(_startTime.format(context), style: const TextStyle(color: kTextSecondary)),
                      tileColor: kSurfaceDark,
                      onTap: () async {
                         final picked = await showTimePicker(context: context, initialTime: _startTime);
                         if (picked != null) setState(() => _startTime = picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      title: const Text('End', style: TextStyle(color: Colors.white)),
                      subtitle: Text(_endTime.format(context), style: const TextStyle(color: kTextSecondary)),
                      tileColor: kSurfaceDark,
                      onTap: () async {
                         final picked = await showTimePicker(context: context, initialTime: _endTime);
                         if (picked != null) setState(() => _endTime = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location (e.g. Room 301)', filled: true, fillColor: Colors.white),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<SessionType>(
                value: _sessionType,
                 decoration: const InputDecoration(labelText: 'Type', filled: true, fillColor: Colors.white),
                items: SessionType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.toString().split('.').last))).toList(),
                onChanged: (v) => setState(() => _sessionType = v!),
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveSession,
                  style: ElevatedButton.styleFrom(backgroundColor: kAccentGold, foregroundColor: kPrimaryDark),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Save Session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
