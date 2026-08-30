import 'package:gutta_clone/core/models/task_models.dart';

/// Repository interface for task persistence.
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task?> getTaskById(String id);
  Future<void> saveTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}
