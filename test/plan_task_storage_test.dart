import 'package:flutter_test/flutter_test.dart';
import 'package:plantracker/data/task_storage.dart';
import 'package:plantracker/models/plan_task.dart';

void main() {
  group('PlanTask', () {
    test('serializes to and from JSON', () {
      const task = PlanTask(
        title: 'Design sync',
        category: 'Work',
        dueDate: 'Today, 4:00 PM',
        completed: false,
        progress: 0.5,
        accentColorValue: 0xFF7C8CFF,
        totalSteps: 4,
        completedSteps: 2, id: '',
      );

      final json = task.toJson();
      final decoded = PlanTask.fromJson(json);

      expect(decoded.title, 'Design sync');
      expect(decoded.category, 'Work');
      expect(decoded.progress, 0.5);
      expect(decoded.accentColorValue, 0xFF7C8CFF);
    });
  });

  group('TaskStorage', () {
    test('provides default seeded tasks', () {
      final tasks = TaskStorage.defaultTasks();

      expect(tasks.isNotEmpty, isTrue);
      expect(tasks.first.title.isNotEmpty, isTrue);
    });
  });
}
