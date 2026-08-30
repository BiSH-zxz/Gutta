# Component Taxonomy

This document explains all the screens and major components in the app using simple language. No technical details are included.

---

## Screens

### Home Screen
The main screen you see when opening the app. It shows:
- A text input at the top for quickly adding new tasks
- Four sections listing your tasks:
  - **Overdue**: Tasks that were due before today
  - **Today**: Tasks due today
  - **Later**: Tasks due after today
  - **Completed**: Tasks you have finished

### Quick Add Screen
A focused screen for rapidly capturing tasks. When you type a sentence like "call john tomorrow at 5pm", the app understands what you mean and creates the task. This screen can be opened directly from:
- The home screen input
- The Android launcher shortcut (long-press the app icon)
- The home-screen widget

### Task Edit Screen
Opens when you tap on an existing task. Allows you to:
- Change the task title
- Change the due date
- Change the due time
- Change the reminder setting
- Mark the task as complete or incomplete
- Delete the task

### Settings Screen
A simple screen with app-wide settings. Currently includes:
- Default reminder timing (Off, 15 min, 20 min, 30 min, 1 hour, 2 hours)

### Search Mode
Not a separate screen, but a mode you can enter from the home screen. Lets you type to find tasks by their title. Clearing the search returns you to the normal task list.

---

## Major Components

### Natural Language Parser
A component that reads what you type and figures out:
- What is the task title (e.g., "call john")
- What date is it due (e.g., "tomorrow", "Friday")
- What time is it due (e.g., "5pm", "17:00")

It removes scheduling words from the title so "send invoice Friday at 10:30" becomes just "send invoice" with the date and time stored separately.

### Task Draft
A temporary representation of a task created by the parser. It holds the title, date, and time before the task is actually saved.

### Task
A saved task in the app. Contains:
- A unique ID
- Title
- Due date and whether it has an explicit time
- Reminder setting
- Whether it is completed
- When it was created
- When it was completed (if applicable)

### Task Service
Handles all operations on tasks:
- Creating new tasks from drafts
- Updating existing tasks
- Deleting tasks
- Marking tasks as complete or incomplete

### Task Classifier
Decides which section a task belongs in:
- Overdue
- Today
- Later
- Completed

It uses the current date/time and the task's due date to make this decision.

### Task Repository
Saves and loads tasks from local storage on your phone. Only handles storage, not business logic.

### Reminder Scheduler
Handles scheduling notifications for tasks. It:
- Schedules a reminder for a task at the right time
- Cancels reminders when tasks are completed or deleted
- Updates reminders when tasks are edited

### App Settings
Stores user preferences like the default reminder timing.

---

## Android-Specific Components

### Launcher Shortcut
When you long-press the app icon on your Android home screen, you see an "Add Task" option. Tapping it opens the Quick Add screen directly.

### Home-Screen Widget
A small widget you can place on your Android home screen. It shows an "Add Task" button that opens the Quick Add screen when tapped.

### Notification System
Shows reminder notifications at the scheduled time, even when the app is closed or the phone is locked.

---

## How It All Works Together

1. You type a task sentence in Quick Add
2. The Parser reads it and creates a Task Draft
3. The Task Service saves it as a Task
4. The Classifier decides where it appears in the list
5. The Reminder Scheduler sets up a notification if needed
6. You can later edit, complete, or delete the task
7. Search helps you find tasks by title
