# Assignment Feature Write-up

## What I struggled with (and how I solved it)

The biggest challenge for me was making the full assignment flow feel consistent end-to-end:

- create an assignment
- see it in the list
- open details
- edit or delete
- return back and immediately see the updated data

At first, I could change the data, but the UI didn’t always refresh reliably after navigation. I realized that in Flutter, navigation returns don’t automatically trigger rebuilds unless I explicitly update state.

### 1) Keeping the UI in sync after navigation

To solve this, I made the assignments screen stateful and treated navigation as part of the update flow:

- When I push the details page from the list, I `await` the navigation.
- When the user returns, I call `setState(() {})` so the list rebuilds and pulls the latest assignments from the data provider.

This keeps the list accurate after edits/deletes without needing extra state management packages.

### 2) Editing from the details page without stale data

Another issue I ran into was that when I edited an assignment from the details screen, the details UI could show stale data unless I refreshed the local copy.

My solution was:

- Open the edit screen using `Navigator.push(...)` and wait for the result.
- In the edit screen, after saving successfully, return `true` using `Navigator.pop(context, true)`.
- Back in the details screen, if the result is `true`, re-fetch the updated assignment from the provider and update the local state.

That way, the details screen updates immediately after edits.

### 3) Reusable assignment cards (tap-to-open)

I also struggled a bit with making the UI components reusable. My assignment card widget originally only displayed information. Once I needed to navigate to details from different places (Assignments list and Dashboard), I updated the widget to accept an optional `onTap` callback.

By wrapping the card in an `InkWell` and using that callback, I could keep one card UI and still make it interactive wherever I needed it.

### 4) Form validation + date picking

I wanted the create/edit form to feel like a real input flow, not just a UI mock. The tricky part was keeping the edit screen flexible enough to handle both:

- Creating a new assignment
- Editing an existing assignment

I handled that by passing an optional `assignment` object into the screen. In `initState()`, I initialize the form fields from either the passed assignment (edit mode) or default values (create mode). For due dates, I used `showDatePicker()` and stored the selected date in `_selectedDate`.

## How we are storing data (and why we chose it)

For this assignment, I intentionally used **in-memory storage**.

### What that means in our app

- Assignments are stored in a mutable list in a simple provider class (`MockDataProvider`).
- I perform CRUD operations by directly modifying that list:
  - `addAssignment(Assignment assignment)`
  - `updateAssignment(Assignment updatedAssignment)`
  - `deleteAssignment(String id)`
- For views like priority tabs, I added helper methods like `getAssignmentsByPriority(String priority)`.
- I also sort the assignments by due date in the `assignments` getter to keep the UI consistently ordered.

### Why I chose in-memory storage

This is a **design choice for the assignment**, not a flaw.

I chose in-memory storage because it let me focus on the core learning objectives:

- building a clean CRUD workflow
- implementing navigation between screens
- managing UI refresh correctly when data changes
- adding filtering (tabs by priority)

Using a database or persistent storage (like SharedPreferences, Hive, SQLite, etc.) would add extra complexity that isn’t necessary for demonstrating the assignment feature.

### Trade-off (intentional)

The main trade-off is that **data does not persist after app restart**.

So if the app is closed and reopened, assignments return to the initial mock data. For this project’s scope, that’s expected and acceptable.
