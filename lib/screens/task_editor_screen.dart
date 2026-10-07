import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../models/plan_task.dart';

class TaskEditorScreen extends StatefulWidget {
  final TaskController taskController;
  final PlanTask? task;

  const TaskEditorScreen({
    super.key,
    required this.taskController,
    this.task,
  });

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _dueDateController;
  late String _category;
  late bool _completed;
  late double _progress;

  static const Map<String, int> categoryColors = {
    'Work': 0xFF7C8CFF,
    'Personal': 0xFF7AD8B0,
    'Urgent': 0xFFFF9E7A,
  };

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _dueDateController = TextEditingController(text: task?.dueDate ?? 'Today, 9:00 AM');
    _category = task?.category ?? 'Work';
    _completed = task?.completed ?? false;
    _progress = task?.progress ?? 0.0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final dueDate = _dueDateController.text.trim();
    final accentColor = categoryColors[_category] ?? 0xFF7C8CFF;

    final task = (widget.task != null)
        ? widget.task!.copyWith(
            title: title,
            category: _category,
            dueDate: dueDate,
            completed: _completed,
            progress: _progress,
            accentColorValue: accentColor,
          )
        : PlanTask(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            category: _category,
            dueDate: dueDate,
            completed: _completed,
            progress: _progress,
            accentColorValue: accentColor,
            totalSteps: widget.task?.totalSteps ?? 4,
            completedSteps: _completed ? widget.task?.totalSteps ?? 4 : widget.task?.completedSteps ?? 0,
          );

    if (widget.task != null) {
      await widget.taskController.updateTask(task);
    } else {
      await widget.taskController.addTask(task);
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _deleteTask() async {
    final task = widget.task;
    if (task == null) {
      return;
    }

    await widget.taskController.deleteTask(task.id);
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New plan' : 'Edit plan'),
        actions: [
          if (widget.task != null)
            IconButton(
              onPressed: _deleteTask,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task == null ? 'Create a new plan' : 'Update your plan',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Plan title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categoryColors.keys
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due date',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Completed'),
                    const Spacer(),
                    Switch(
                      value: _completed,
                      onChanged: (value) {
                        setState(() {
                          _completed = value;
                          if (value) {
                            _progress = 1.0;
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Progress: ${(_progress * 100).round()}%'),
                const SizedBox(height: 8),
                Slider(
                  value: _progress,
                  min: 0,
                  max: 1,
                  divisions: 20,
                  onChanged: (value) {
                    setState(() {
                      _progress = value;
                      _completed = value >= 1.0;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save plan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
