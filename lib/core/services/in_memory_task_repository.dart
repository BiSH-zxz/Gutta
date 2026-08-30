import 'package:gutta_clone/core/models/task_models.dart';
import 'package:gutta_clone/core/services/task_repository.dart';

/// In-memory implementation of TaskRepository for testing and initial use.
class InMemoryTaskRepository implements TaskRepository {
  final Map<String, Task> _tasks = {};

  @override
  Future<List<Task>> getTasks() async {
    return _tasks.values.toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return _tasks[id];
  }

  @override
  Future<void> saveTask(Task task) async {
    _tasks[task.id.value] = task;
  }

  @override
  Future<void> updateTask(Task task) async {
    _tasks[task.id.value] = task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.remove(id);
  }

  /// Clears all tasks (useful for testing).
  void clear() {
    _tasks.clear();
  }

  /// Returns the number of stored tasks (useful for testing).
  int get count => _tasks.length;
}
