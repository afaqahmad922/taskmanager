import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.teal[800],
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: TaskManagerHomePage(),
    );
  }
}

class TaskManagerHomePage extends StatefulWidget {
  @override
  _TaskManagerHomePageState createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  List<Task> _tasks = [];

  void _addTask() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog();
      },
    );

    if (task != null) {
      setState(() {
        _tasks.add(task);
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addTask,
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
        child: Text(
          'No tasks added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: Key(task.title),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteTask(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: TaskCard(
              task: task,
              onToggleCompletion: () => _toggleTaskCompletion(index),
              onDelete: () => _deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;

  TaskCard({
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: onToggleCompletion,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: task.isCompleted ? Colors.green : Colors.grey,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                task.isCompleted ? Icons.check : Icons.circle,
                color: task.isCompleted ? Colors.green : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text('Add'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          onPressed: () {
            final title = _titleController.text;
            final description = _descriptionController.text;

            if (title.isNotEmpty && description.isNotEmpty) {
              final task = Task(title, description);
              Navigator.pop(context, task);
            }
          },
        ),
      ],
    );
  }
}

class Task {
  final String title;
  final String description;
  bool isCompleted;

  Task(this.title, this.description, {this.isCompleted = false});
}
