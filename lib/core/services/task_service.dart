import 'package:gutta_clone/core/models/task_models.dart';
import 'package:gutta_clone/core/services/id_generator.dart';
import 'package:gutta_clone/core/services/task_repository.dart';

/// Service for task operations.
abstract class TaskService {
  Future<Task> createTask(TaskDraft draft);
  Future<List<Task>> createTasks(List<TaskDraft> drafts);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<void> completeTask(String taskId);
  Future<void> uncompleteTask(String taskId);
}

/// Default implementation of TaskService.
class DefaultTaskService implements TaskService {
  final TaskRepository repository;
  final IdGenerator idGenerator;

  DefaultTaskService({
    required this.repository,
    required this.idGenerator,
  });

  @override
  Future<Task> createTask(TaskDraft draft) async {
    final id = TaskId(idGenerator.generate());
    final now = DateTime.now();
    final task = Task.fromDraft(draft, id, now);
    await repository.saveTask(task);
    return task;
  }

  @override
  Future<List<Task>> createTasks(List<TaskDraft> drafts) async {
    final tasks = <Task>[];
    for (final draft in drafts) {
      final task = await createTask(draft);
      tasks.add(task);
    }
    return tasks;
  }

  @override
  Future<void> updateTask(Task task) async {
    await repository.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await repository.deleteTask(taskId);
  }

  @override
  Future<void> completeTask(String taskId) async {
    final task = await repository.getTaskById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    final completedTask = task.markCompleted(DateTime.now());
    await repository.updateTask(completedTask);
  }

  @override
  Future<void> uncompleteTask(String taskId) async {
    final task = await repository.getTaskById(taskId);
    if (task == null) {
      throw Exception('Task not found: $taskId');
    }
    final incompleteTask = task.markIncomplete();
    await repository.updateTask(incompleteTask);
  }
}
