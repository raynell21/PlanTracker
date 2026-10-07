import 'package:flutter_test/flutter_test.dart';
import 'package:plantracker/models/plan_task.dart';
import 'package:plantracker/data/task_repository.dart';

void main() {
  group('PlanTask', () {
    test('serializes to and from JSON', () {
      final task = PlanTask(
        id: 'task-1',
        title: 'Ship feature',
        category: 'Work',
        dueDate: '2026-10-02T16:00:00.000',
        completed: false,
        progress: 0.5,
        accentColorValue: 0xFF7C8CFF,
        totalSteps: 4,
        completedSteps: 2,
      );

      final json = task.toJson();
      final decoded = PlanTask.fromJson(json);

      expect(decoded.id, 'task-1');
      expect(decoded.title, 'Ship feature');
      expect(decoded.completed, isFalse);
      expect(decoded.progress, 0.5);
      expect(decoded.accentColorValue, 0xFF7C8CFF);
    });
  });

  group('TaskRepository', () {
    test('stores and returns tasks', () async {
      final repository = TaskRepository();
      await repository.saveTasks([
        PlanTask(
          id: 'task-1',
          title: 'Write release notes',
          category: 'Work',
          dueDate: '2026-10-03T09:00:00.000',
          completed: false,
          progress: 0.25,
          accentColorValue: 0xFF7AD8B0,
          totalSteps: 4,
          completedSteps: 1,
        ),
      ]);

      final tasks = await repository.loadTasks();

      expect(tasks.length, 1);
      expect(tasks.first.title, 'Write release notes');
      expect(tasks.first.category, 'Work');
    });
  });
}
