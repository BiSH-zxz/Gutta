import 'package:gutta_clone/core/models/task_models.dart';

/// Task group classification.
enum TaskGroup {
  overdue,
  today,
  later,
  completed,
}

/// Classifier for tasks into groups.
class TaskClassifier {
  /// Classifies a task into a group based on its state and due date.
  TaskGroup classifyTask(Task task, DateTime now) {
    // Completed tasks go to completed group
    if (task.completed) {
      return TaskGroup.completed;
    }

    // No due date means it's in "Later"
    if (task.dueDate == null) {
      return TaskGroup.later;
    }

    final dueDate = task.dueDate!;
    final nowDate = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    // For timed tasks, check if the exact time has passed
    if (task.hasExplicitTime) {
      if (dueDate.isBefore(now)) {
        return TaskGroup.overdue;
      }
      if (dueDateOnly.isAtSameMomentAs(nowDate)) {
        return TaskGroup.today;
      }
      if (dueDate.isAfter(now)) {
        return TaskGroup.later;
      }
    }

    // For date-only tasks, compare calendar dates
    if (dueDateOnly.isBefore(nowDate)) {
      return TaskGroup.overdue;
    } else if (dueDateOnly.isAtSameMomentAs(nowDate)) {
      return TaskGroup.today;
    } else {
      return TaskGroup.later;
    }
  }

  /// Filters tasks by group.
  List<Task> filterByGroup(List<Task> tasks, TaskGroup group, DateTime now) {
    return tasks
        .where((task) => classifyTask(task, now) == group)
        .toList();
  }
}
