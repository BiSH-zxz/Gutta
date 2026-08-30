import 'package:gutta_clone/core/models/task_models.dart';

/// Scheduler interface for reminders.
abstract class ReminderScheduler {
  /// Schedules a reminder for a task.
  Future<void> scheduleForTask(Task task, {required AppSettings settings});

  /// Cancels a reminder for a task.
  Future<void> cancelForTask(String taskId);

  /// Reconciles all reminders based on current tasks and settings.
  Future<void> reconcile(List<Task> tasks, AppSettings settings);
}
