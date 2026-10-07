import 'package:shared_preferences/shared_preferences.dart';

import '../models/plan_task.dart';

class TaskRepository {
  static const String _storageKey = 'plantracker_tasks';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<List<PlanTask>> loadTasks() async {
    final prefs = await _instance;
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return const [];
    }

    return PlanTask.decodeList(raw);
  }

  Future<void> saveTasks(List<PlanTask> tasks) async {
    final prefs = await _instance;
    await prefs.setString(_storageKey, PlanTask.encodeList(tasks));
  }

  Future<void> updateTask(PlanTask task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((item) => item.id == task.id);

    if (index == -1) {
      tasks.add(task);
    } else {
      tasks[index] = task;
    }

    await saveTasks(tasks);
  }

  static List<PlanTask> defaultTasks() {
    return const [
      PlanTask(
        id: 'task-1',
        title: 'Product strategy review',
        category: 'Work',
        dueDate: 'Today, 4:30 PM',
        completed: false,
        progress: 0.72,
        accentColorValue: 0xFF7C8CFF,
        totalSteps: 5,
        completedSteps: 3,
      ),
      PlanTask(
        id: 'task-2',
        title: 'Gym and recovery session',
        category: 'Personal',
        dueDate: 'Tomorrow, 7:00 AM',
        completed: true,
        progress: 1.0,
        accentColorValue: 0xFF7AD8B0,
        totalSteps: 3,
        completedSteps: 3,
      ),
      PlanTask(
        id: 'task-3',
        title: 'Client follow-up sprint',
        category: 'Urgent',
        dueDate: 'Today, 2:00 PM',
        completed: false,
        progress: 0.41,
        accentColorValue: 0xFFFF9E7A,
        totalSteps: 4,
        completedSteps: 2,
      ),
      PlanTask(
        id: 'task-4',
        title: 'Home cleanup checklist',
        category: 'Personal',
        dueDate: 'Fri, 8:00 PM',
        completed: false,
        progress: 0.58,
        accentColorValue: 0xFF8BC6FF,
        totalSteps: 5,
        completedSteps: 3,
      ),
      PlanTask(
        id: 'task-5',
        title: 'Launch meeting prep',
        category: 'Work',
        dueDate: 'Mon, 10:00 AM',
        completed: false,
        progress: 0.28,
        accentColorValue: 0xFF9D8CFF,
        totalSteps: 6,
        completedSteps: 2,
      ),
    ];
  }
}
