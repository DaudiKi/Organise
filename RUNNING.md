# Running the ALU Student Platform App

## Quick Start Guide

### 1. Check for Available Emulators
```powershell
C:\flutter\bin\flutter emulators
```

This will list all configured Android emulators on your system.

### 2. Launch an Emulator

**Option A: Launch a specific emulator**
```powershell
C:\flutter\bin\flutter emulators --launch <emulator_id>
```
Replace `<emulator_id>` with the ID from the list above (e.g., `Pixel_5_API_30`).

**Option B: Open Android Studio and launch from AVD Manager**
1. Open Android Studio
2. Click "More Actions" → "Virtual Device Manager"
3. Click the play button next to any emulator
4. Wait for emulator to fully boot

### 3. Run the App
```powershell
cd d:\Formative_Assignment_1
C:\flutter\bin\flutter run
```

The app will compile and launch on your emulator. First run may take 1-2 minutes.

### 4. Hot Reload During Development
Once running, you can make code changes and press:
- `r` - Hot reload (fastest, preserves state)
- `R` - Hot restart (full restart)
- `q` - Quit

---

## What You Should See

When the app launches successfully, you'll see:

### Dashboard Screen (First Tab)
- **Top Section**: Current date "Thursday, February 6, 2026" and "Week 5"
- **Warning Banner**: Red "AT RISK WARNING" (because mock attendance is 50%)
- **Stats Cards**: 
  - 4 Active Projects
  - 7 Code Sectors  
  - 1 Upcoming Agendas
  - 50% Attendance (red background)
  - 4 Pending Assignments (gold background)
- **Today's Classes**: List of 3 sessions scheduled for today
- **Assignments**: List of 3 assignments due within 7 days

### Bottom Navigation
- **Dashboard** (house icon) - Currently active
- **Assignments** (assignment icon) - Placeholder screen
- **Schedule** (calendar icon) - Placeholder screen

---

## Troubleshooting

### "No devices found"
**Problem**: No emulator is running.
**Solution**: Launch an emulator first (see step 2 above).

### "flutter: command not found"
**Problem**: Flutter not in PATH.
**Solution**: Use full path: `C:\flutter\bin\flutter run`

### Build errors
**Problem**: Dependencies not installed.
**Solution**: Run `C:\flutter\bin\flutter pub get` then try again.

### Emulator too slow
**Problem**: Emulator performance issues.
**Solution**: 
- Create a new emulator with less RAM (2GB instead of 4GB)
- Enable hardware acceleration in BIOS
- Use a physical device instead

---

## Testing the Features

Once the app is running, test these features:

1. ✅ **Date Display**: Should show today's date and week number
2. ✅ **Warning Banner**: Red banner should be visible (mock data has <75% attendance)
3. ✅ **Stats Cards**: All should display correct numbers
4. ✅ **Sessions List**: Should show 3 sessions for today
5. ✅ **Assignments List**: Should show 3 assignments due within 7 days
6. ✅ **Navigation**: Tap each bottom tab to verify navigation works

---

## Recording Demo Video

For your assignment submission:

1. **Start Screen Recording** (on Windows):
   - Press `Windows + G` to open Game Bar
   - Click the record button or press `Windows + Alt + R`

2. **Run the app and demonstrate**:
   - Launch the app
   - Show the dashboard with all features
   - Scroll through sessions and assignments
   - Tap each navigation tab
   - Explain each feature as you demo

3. **Stop Recording**:
   - Press `Windows + Alt + R` again

4. **Video location**: 
   - Videos saved to: `C:\Users\<username>\Videos\Captures\`

---

## Making Changes

### Update Mock Data
Edit `lib/data/mock_data.dart` to change:
- Sample assignments
- Sample sessions
- Attendance percentage
- Academic week calculation

### Change Colors
Edit `lib/main.dart` (lines 16-25) to modify the theme colors.

### Add More Features
Continue building on this foundation for:
- Assignment CRUD operations
- Session scheduling
- Data persistence
