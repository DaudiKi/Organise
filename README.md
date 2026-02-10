# ALU Student Academic Platform

A mobile application that serves as a personal academic assistant for African Leadership University students, helping them organize coursework, track schedules, and monitor academic engagement.

## Project Overview

This Flutter application addresses the common challenge ALU students face in managing academic responsibilities while balancing university life. The app helps students track assignments, remember class schedules, and monitor attendance.

## Features Implemented

### Home Dashboard ✅
- **Date & Academic Week**: Displays current date and calculated academic week number
- **Today's Sessions**: Lists all scheduled academic sessions for today
- **Upcoming Assignments**: Shows assignments due within the next 7 days
- **Attendance Tracking**: Displays overall attendance percentage with visual warning when below 75%
- **Quick Stats**: Summary counts for active projects, pending assignments, and more
- **ALU Branding**: Professional interface with official ALU colors (Dark Navy, Gold, White)

### Navigation
- Bottom navigation bar with 3 tabs:
  - **Dashboard** - Main overview screen
  - **Assignments** - Assignment management (placeholder)
  - **Schedule** - Session planning (placeholder)

## Technology Stack

- **Framework**: Flutter 3.6.0
- **Language**: Dart
- **Dependencies**:
  - `intl: ^0.19.0` - Date formatting and internationalization
  - `cupertino_icons: ^1.0.8` - iOS style icons

## Project Structure

```
lib/
├── main.dart                          # App entry point with navigation
├── data/
│   └── mock_data.dart                # Sample data provider
├── models/
│   ├── assignment.dart               # Assignment data model
│   └── session.dart                  # Session data model
├── screens/
│   ├── dashboard_screen.dart         # Main dashboard screen
│   ├── assignments_screen.dart       # Assignments tab (placeholder)
│   └── schedule_screen.dart          # Schedule tab (placeholder)
└── widgets/
    ├── date_header_widget.dart       # Date and week display
    ├── attendance_warning_widget.dart # At-risk warning banner
    ├── stats_card_widget.dart        # Reusable stat cards
    ├── session_card_widget.dart      # Session display cards
    └── assignment_card_widget.dart   # Assignment display cards
```

## Getting Started

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Android Studio or VS Code with Flutter extensions
- Android Emulator or physical device

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd Formative_Assignment_1
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Running on Emulator

1. **List available emulators**:
   ```bash
   flutter emulators
   ```

2. **Launch an emulator**:
   ```bash
   flutter emulators --launch <emulator_id>
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Testing

### Run all tests:
```bash
flutter test
```

### Run code analysis:
```bash
flutter analyze
```

## ALU Color Palette

The app uses ALU's official branding colors:
- **Primary Background**: `#0D1B2A` (Dark Navy Blue)
- **Accent Color**: `#F5A623` (Gold/Yellow)
- **Surface/Cards**: `#1B263B` (Dark Blue)
- **Warning/Error**: `#C41E3A` (Red)
- **Text**: `#FFFFFF` (White)

## Team Contribution

This project is a group assignment. Individual contributions:

- **Home Dashboard**: [Your Name] - Implemented dashboard screen with all required features
- **Assignment Management**: [Teammate] - To be implemented
- **Schedule Management**: [Teammate] - To be implemented

## Assignment Requirements Met

### Core Features
- ✅ Today's date and academic week display
- ✅ List of today's scheduled sessions
- ✅ Assignments due within 7 days
- ✅ Overall attendance percentage
- ✅ Visual warning when attendance < 75%
- ✅ Pending assignments count

### Technical Requirements
- ✅ BottomNavigationBar with 3 tabs
- ✅ ALU branding colors applied
- ✅ Professional and intuitive UI
- ✅ Responsive mobile design
- ✅ No pixel overflow errors
- ✅ Clear navigation patterns

## Future Enhancements

- [ ] Assignment CRUD operations
- [ ] Session scheduling with calendar view
- [ ] Data persistence (SharedPreferences or SQLite)
- [ ] Attendance recording interface
- [ ] Push notifications for deadlines
- [ ] Dark/Light theme toggle

## Academic Integrity

This project represents original work by the development team. AI tools were used only for learning and debugging assistance, with all core code written and understood by team members.

## License

This project is created for academic purposes as part of the ALU curriculum.

## Contact

For questions or collaboration:
- Repository: [GitHub Repository Link]
- Contributors: [Team Members]

---

**African Leadership University**  
*Building Africa's future leaders*
