import 'package:flutter/material.dart';

import 'package:plantracker/controllers/task_controller.dart';
import 'package:plantracker/models/plan_task.dart';
import 'package:plantracker/screens/task_editor_screen.dart';

void main() {
  runApp(const PlanTrackerApp());
}

class PlanTrackerApp extends StatefulWidget {
  const PlanTrackerApp({super.key});

  @override
  State<PlanTrackerApp> createState() => _PlanTrackerAppState();
}

class _PlanTrackerAppState extends State<PlanTrackerApp> {
  late final TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController();
    _taskController.loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _taskController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PlanTracker',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF5F7FF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1F2A44),
              brightness: Brightness.light,
            ),
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF1F2937),
              displayColor: const Color(0xFF111827),
            ),
          ),
          home: DashboardScreen(taskController: _taskController),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final TaskController taskController;

  const DashboardScreen({
    super.key,
    required this.taskController,
  });

  List<PlanTask> get filteredTasks {
    if (taskController.tasks.isEmpty) {
      return const [];
    }

    return taskController.tasks;
  }

  Future<void> _openTaskEditor(BuildContext context, [PlanTask? task]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(
          taskController: taskController,
          task: task,
        ),
      ),
    );

    if (context.mounted) {
      await taskController.loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (taskController.isLoading && taskController.tasks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1100;
        final isTablet = constraints.maxWidth >= 700;
        final horizontalPadding = isDesktop ? 32.0 : isTablet ? 24.0 : 18.0;
        final tasks = taskController.tasks;
        final pendingTasks = tasks.where((task) => !task.completed).length;

        return DashboardView(
          taskController: taskController,
          tasks: tasks,
          pendingTasks: pendingTasks,
          onAddTask: () => _openTaskEditor(context),
          onEditTask: (task) => _openTaskEditor(context, task),
          horizontalPadding: horizontalPadding,
        );
      },
    );
  }
}

class DashboardView extends StatefulWidget {
  final TaskController taskController;
  final List<PlanTask> tasks;
  final int pendingTasks;
  final VoidCallback onAddTask;
  final ValueChanged<PlanTask> onEditTask;
  final double horizontalPadding;

  const DashboardView({
    super.key,
    required this.taskController,
    required this.tasks,
    required this.pendingTasks,
    required this.onAddTask,
    required this.onEditTask,
    required this.horizontalPadding,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String selectedFilter = 'All';

  List<PlanTask> get filteredTasks {
    if (selectedFilter == 'All') {
      return widget.tasks;
    }
    return widget.tasks.where((task) => task.category == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width >= 1100 ? 24 : 16),
        child: FloatingActionButton.extended(
          onPressed: widget.onAddTask,
          backgroundColor: const Color(0xFF1F2A44),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('New plan'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width >= 1100 ? 1280 : 900),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                widget.horizontalPadding,
                18,
                widget.horizontalPadding,
                96,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    userName: 'Maya',
                    todayLabel: 'Thursday, Sep 30',
                    tasksLeft: widget.pendingTasks,
                  ),
                  const SizedBox(height: 24),
                  SummaryRow(tasks: widget.tasks),
                  const SizedBox(height: 24),
                  FilterChipRow(
                    selectedFilter: selectedFilter,
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Today’s plans',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...filteredTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: GestureDetector(
                      onTap: () => widget.onEditTask(task),
                      child: TaskCard(
                        task: task,
                        onToggleCompletion: () async {
                          await widget.taskController.toggleTask(task);
                        },
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String todayLabel;
  final int tasksLeft;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.todayLabel,
    required this.tasksLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F2A44), Color(0xFF4256A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2A44).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, $userName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todayLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_note_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$tasksLeft left',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final List<PlanTask> tasks;

  const SummaryRow({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.completed).length;
    final pendingTasks = totalTasks - completedTasks;

    final metrics = [
      SummaryCard(
        title: 'Total Tasks',
        value: totalTasks.toString(),
        icon: Icons.checklist_rounded,
        accent: const Color(0xFF5667D8),
        detail: '+12% from last week',
      ),
      SummaryCard(
        title: 'Completed',
        value: completedTasks.toString(),
        icon: Icons.done_all_rounded,
        accent: const Color(0xFF43B581),
        detail: 'Good momentum',
      ),
      SummaryCard(
        title: 'Pending',
        value: pendingTasks.toString(),
        icon: Icons.schedule_rounded,
        accent: const Color(0xFFFFB067),
        detail: 'Needs focus',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900 ? 3 : 1;
        final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: metrics.map((metric) {
            return SizedBox(
              width: itemWidth < 220 ? 220 : itemWidth,
              child: metric,
            );
          }).toList(),
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final String detail;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent),
              ),
              const Spacer(),
              Icon(Icons.trending_up_rounded, color: accent.withValues(alpha: 0.85)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const FilterChipRow({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  static const List<String> filters = ['All', 'Work', 'Personal', 'Urgent'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: filters.map((filter) {
        final isSelected = filter == selectedFilter;
        return ChoiceChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (_) => onSelected(filter),
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          selectedColor: const Color(0xFFE4E8FF),
          backgroundColor: Colors.white,
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? const Color(0xFF1F2A44) : const Color(0xFF4B5563),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }
}

class TaskCard extends StatelessWidget {
  final PlanTask task;
  final VoidCallback onToggleCompletion;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final progressValue = (task.progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.completed,
            activeColor: task.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (_) => onToggleCompletion(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: task.accentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        task.category,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: task.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.dueDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: task.progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(task.accentColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$progressValue% complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${task.completedSteps}/${task.totalSteps} steps',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
