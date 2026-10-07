import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/plan_task.dart';

class TaskStorage {
  static const String _tasksKey = 'plantracker_tasks';

  static List<PlanTask> defaultTasks() {
    return [
      const PlanTask(
        id: 'product-strategy-review',
        title: 'Product strategy review',
        category: 'Work',
        dueDate: 'Today, 4:30 PM',
        completed: false,
        progress: 0.72,
        accentColorValue: 0xFF7C8CFF,
        totalSteps: 5,
        completedSteps: 3,
      ),
      const PlanTask(
        id: 'gym-recovery-session',
        title: 'Gym and recovery session',
        category: 'Personal',
        dueDate: 'Tomorrow, 7:00 AM',
        completed: true,
        progress: 1.0,
        accentColorValue: 0xFF7AD8B0,
        totalSteps: 3,
        completedSteps: 3,
      ),
      const PlanTask(
        id: 'client-follow-up-sprint',
        title: 'Client follow-up sprint',
        category: 'Urgent',
        dueDate: 'Today, 2:00 PM',
        completed: false,
        progress: 0.41,
        accentColorValue: 0xFFFF9E7A,
        totalSteps: 4,
        completedSteps: 2,
      ),
      const PlanTask(
        id: 'home-cleanup-checklist',
        title: 'Home cleanup checklist',
        category: 'Personal',
        dueDate: 'Fri, 8:00 PM',
        completed: false,
        progress: 0.58,
        accentColorValue: 0xFF8BC6FF,
        totalSteps: 5,
        completedSteps: 3,
      ),
      const PlanTask(
        id: 'launch-meeting-prep',
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

  Future<List<PlanTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTasks = prefs.getStringList(_tasksKey);

    if (rawTasks == null || rawTasks.isEmpty) {
      final seededTasks = defaultTasks();
      await saveTasks(seededTasks);
      return seededTasks;
    }

    return rawTasks
        .map((jsonString) => PlanTask.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> saveTasks(List<PlanTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();

    await prefs.setStringList(_tasksKey, encodedTasks);
  }
}
