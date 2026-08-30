import 'package:flutter_test/flutter_test.dart';
import 'package:gutta_clone/core/models/task_models.dart';
import 'package:gutta_clone/core/services/task_classifier.dart';

void main() {
  group('TaskClassifier', () {
    late TaskClassifier classifier;

    setUp(() {
      classifier = TaskClassifier();
    });

    group('classifyTask', () {
      test('completed task is classified as completed', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          completed: true,
          completedAt: now,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.completed));
      });

      test('task with no due date is classified as later', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          dueDate: null,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.later));
      });

      test('overdue date-only task is classified as overdue', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 14); // Yesterday
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(days: 2)),
          dueDate: dueDate,
          hasExplicitTime: false,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.overdue));
      });

      test('today date-only task is classified as today', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 15); // Today
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          dueDate: dueDate,
          hasExplicitTime: false,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.today));
      });

      test('future date-only task is classified as later', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 16); // Tomorrow
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          dueDate: dueDate,
          hasExplicitTime: false,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.later));
      });

      test('overdue timed task is classified as overdue', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 15, 9, 0); // Today at 9am (past)
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 2)),
          dueDate: dueDate,
          hasExplicitTime: true,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.overdue));
      });

      test('today timed task in future is classified as today', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 15, 14, 0); // Today at 2pm (future)
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          dueDate: dueDate,
          hasExplicitTime: true,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.today));
      });

      test('future timed task is classified as later', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final dueDate = DateTime(2024, 1, 16, 14, 0); // Tomorrow at 2pm
        final task = Task(
          id: const TaskId('test-id'),
          title: 'Test',
          createdAt: now.subtract(const Duration(hours: 1)),
          dueDate: dueDate,
          hasExplicitTime: true,
        );

        expect(classifier.classifyTask(task, now), equals(TaskGroup.later));
      });
    });

    group('filterByGroup', () {
      test('filters tasks by group correctly', () {
        final now = DateTime(2024, 1, 15, 10, 0);
        final today = DateTime(2024, 1, 15);
        final yesterday = DateTime(2024, 1, 14);
        final tomorrow = DateTime(2024, 1, 16);

        final tasks = [
          Task(
            id: const TaskId('1'),
            title: 'Completed',
            createdAt: now,
            completed: true,
          ),
          Task(
            id: const TaskId('2'),
            title: 'Overdue',
            createdAt: now,
            dueDate: yesterday,
            hasExplicitTime: false,
          ),
          Task(
            id: const TaskId('3'),
            title: 'Today',
            createdAt: now,
            dueDate: today,
            hasExplicitTime: false,
          ),
          Task(
            id: const TaskId('4'),
            title: 'Later',
            createdAt: now,
            dueDate: tomorrow,
            hasExplicitTime: false,
          ),
        ];

        final completed = classifier.filterByGroup(tasks, TaskGroup.completed, now);
        final overdue = classifier.filterByGroup(tasks, TaskGroup.overdue, now);
        final todayTasks = classifier.filterByGroup(tasks, TaskGroup.today, now);
        final later = classifier.filterByGroup(tasks, TaskGroup.later, now);

        expect(completed.length, equals(1));
        expect(completed.first.title, equals('Completed'));

        expect(overdue.length, equals(1));
        expect(overdue.first.title, equals('Overdue'));

        expect(todayTasks.length, equals(1));
        expect(todayTasks.first.title, equals('Today'));

        expect(later.length, equals(1));
        expect(later.first.title, equals('Later'));
      });
    });
  });
}
