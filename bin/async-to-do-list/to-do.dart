import 'dart:convert';
import 'dart:io';

class Task {
  String description;
  bool completed;

  Task({required this.description, this.completed = false});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'completed': completed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      description: json['description'],
      completed: json['completed'],
    );
  }
}

class TaskManager {
  List<Task> tasks = [];
  String filePath;

  TaskManager(this.filePath);

  Future<void> loadTasks() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> taskList = json.decode(jsonString);
        tasks = taskList.map((task) => Task.fromJson(task)).toList();
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> saveTasks() async {
    try {
      final file = File(filePath);
      final jsonString =
          json.encode(tasks.map((task) => task.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  void addTask(String description) {
    final newTask = Task(description: description);
    tasks.add(newTask);
    saveTasks();
  }

  void viewTasks() {
    if (tasks.isEmpty) {
      print('No tasks available.');
    } else {
      for (int i = 0; i < tasks.length; i++) {
        final task = tasks[i];
        print(
            '${i + 1}. ${task.description} - ${task.completed ? "Completed" : "Incomplete"}');
      }
    }
  }

  void removeTask(int index) {
    if (index < 0 || index >= tasks.length) {
      print('Invalid task index.');
    } else {
      tasks.removeAt(index);
      saveTasks();
    }
  }

  void toggleTaskCompletion(int index) {
    if (index < 0 || index >= tasks.length) {
      print('Invalid task index.');
    } else {
      tasks[index].completed = !tasks[index].completed;
      saveTasks();
    }
  }
}

void printUsage() {
  print('Usage:');
  print('  add [task description] - Add a new task');
  print('  view - View all tasks');
  print('  remove [task index] - Remove a task');
  print('  complete [task index] - Toggle task completion');
  print('  exit - Exit the program');
}

void main(List<String> arguments) async {
  final taskManager = TaskManager('tasks.json');
  await taskManager.loadTasks();

  if (arguments.isEmpty || arguments[0] == 'help') {
    printUsage();
  } else {
    switch (arguments[0]) {
      case 'add':
        final description = arguments.sublist(1).join(' ');
        taskManager.addTask(description);
        break;
      case 'view':
        taskManager.viewTasks();
        break;
      case 'remove':
        final index = int.tryParse(arguments[1]) ?? -1;
        taskManager.removeTask(index - 1);
        break;
      case 'complete':
        final index = int.tryParse(arguments[1]) ?? -1;
        taskManager.toggleTaskCompletion(index - 1);
        break;
      case 'exit':
        return;
      default:
        print('Unknown command: ${arguments[0]}');
        printUsage();
    }
  }
}
