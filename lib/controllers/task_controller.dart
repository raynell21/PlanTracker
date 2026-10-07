import 'package:flutter/foundation.dart';

import '../data/task_storage.dart';
import '../models/plan_task.dart';

class TaskController extends ChangeNotifier {
  final TaskStorage _storage = TaskStorage();

  List<PlanTask> _tasks = const [];
  bool _isLoading = true;

  List<PlanTask> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final loadedTasks = await _storage.loadTasks();
    _tasks = loadedTasks;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(PlanTask task) async {
    final nextTasks = [..._tasks, task];
    _tasks = nextTasks;
    await _storage.saveTasks(nextTasks);
    notifyListeners();
  }

  Future<void> updateTask(PlanTask task) async {
    final nextTasks = _tasks
        .map((item) => item.id == task.id ? task : item)
        .toList();

    _tasks = nextTasks;
    await _storage.saveTasks(nextTasks);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final nextTasks = _tasks.where((task) => task.id != id).toList();
    _tasks = nextTasks;
    await _storage.saveTasks(nextTasks);
    notifyListeners();
  }

  Future<void> toggleTask(PlanTask task) async {
    final nextTask = task.copyWith(
      completed: !task.completed,
      progress: !task.completed ? 1.0 : task.progress,
      completedSteps: !task.completed ? task.totalSteps : task.completedSteps,
    );

    await updateTask(nextTask);
  }
}
