import 'package:flutter_test/flutter_test.dart';
import 'package:gutta_clone/core/models/task_models.dart';
import 'package:gutta_clone/core/services/in_memory_task_repository.dart';

void main() {
  group('InMemoryTaskRepository', () {
    late InMemoryTaskRepository repository;

    setUp(() {
      repository = InMemoryTaskRepository();
    });

    test('saveTask and getTasks work correctly', () async {
      final task = Task(
        id: const TaskId('test-id'),
        title: 'Test task',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task);
      final tasks = await repository.getTasks();

      expect(tasks.length, equals(1));
      expect(tasks.first, equals(task));
    });

    test('getTaskById returns correct task', () async {
      final task = Task(
        id: const TaskId('test-id'),
        title: 'Test task',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task);
      final retrieved = await repository.getTaskById('test-id');

      expect(retrieved, equals(task));
    });

    test('getTaskById returns null for non-existent task', () async {
      final retrieved = await repository.getTaskById('non-existent');
      expect(retrieved, isNull);
    });

    test('updateTask updates existing task', () async {
      final task = Task(
        id: const TaskId('test-id'),
        title: 'Original',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task);

      final updated = task.copyWith(title: 'Updated');
      await repository.updateTask(updated);

      final retrieved = await repository.getTaskById('test-id');
      expect(retrieved?.title, equals('Updated'));
    });

    test('deleteTask removes task', () async {
      final task = Task(
        id: const TaskId('test-id'),
        title: 'Test task',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task);
      await repository.deleteTask('test-id');

      final retrieved = await repository.getTaskById('test-id');
      expect(retrieved, isNull);
      expect(repository.count, equals(0));
    });

    test('clear removes all tasks', () async {
      final task1 = Task(
        id: const TaskId('1'),
        title: 'Task 1',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );
      final task2 = Task(
        id: const TaskId('2'),
        title: 'Task 2',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task1);
      await repository.saveTask(task2);

      repository.clear();

      final tasks = await repository.getTasks();
      expect(tasks.length, equals(0));
    });

    test('persistence survives across operations', () async {
      final task = Task(
        id: const TaskId('test-id'),
        title: 'Test task',
        dueDate: DateTime(2024, 1, 16, 14, 0),
        hasExplicitTime: true,
        reminderSetting: ReminderSetting.twentyMinutes,
        completed: false,
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );

      await repository.saveTask(task);

      // Simulate multiple operations
      final tasks1 = await repository.getTasks();
      expect(tasks1.length, equals(1));

      final retrieved = await repository.getTaskById('test-id');
      expect(retrieved, equals(task));

      final tasks2 = await repository.getTasks();
      expect(tasks2.length, equals(1));
      expect(tasks2.first, equals(task));
    });
  });
}
