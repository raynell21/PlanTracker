import 'dart:convert';
import 'dart:ui';

class PlanTask {
  final String id;
  final String title;
  final String category;
  final String dueDate;
  final bool completed;
  final double progress;
  final int accentColorValue;
  final int totalSteps;
  final int completedSteps;

  const PlanTask({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.completed,
    required this.progress,
    required this.accentColorValue,
    required this.totalSteps,
    required this.completedSteps,
  });

  Color get accentColor => Color(accentColorValue);

  PlanTask copyWith({
    String? id,
    String? title,
    String? category,
    String? dueDate,
    bool? completed,
    double? progress,
    int? accentColorValue,
    int? totalSteps,
    int? completedSteps,
  }) {
    return PlanTask(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      progress: progress ?? this.progress,
      accentColorValue: accentColorValue ?? this.accentColorValue,
      totalSteps: totalSteps ?? this.totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }

  factory PlanTask.fromJson(Map<String, dynamic> json) {
    return PlanTask(
      id: json['id'] as String? ?? json['title'] as String? ?? 'task',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      dueDate: json['dueDate'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      accentColorValue: json['accentColorValue'] as int? ?? 0xFF7C8CFF,
      totalSteps: json['totalSteps'] as int? ?? 0,
      completedSteps: json['completedSteps'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'dueDate': dueDate,
      'completed': completed,
      'progress': progress,
      'accentColorValue': accentColorValue,
      'totalSteps': totalSteps,
      'completedSteps': completedSteps,
    };
  }

  static String encodeList(List<PlanTask> tasks) {
    final payload = tasks.map((task) => task.toJson()).toList();
    return jsonEncode(payload);
  }

  static List<PlanTask> decodeList(String rawJson) {
    if (rawJson.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(rawJson);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .map((task) => PlanTask.fromJson(Map<String, dynamic>.from(task)))
        .toList();
  }
}
