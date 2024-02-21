import 'package:flutter/material.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/constants/new_task_type.dart';

class Item extends StatefulWidget {
  final Task task;
  final Function(Task) deleteTask;
  final Function(Task) completeTask;

  const Item({
    Key? key,
    required this.task,
    required this.deleteTask,
    required this.completeTask,
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.task.isCompleted ? Colors.green[200] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          widget.completeTask(widget.task);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.task.type == TaskType.morning
                  ? const Icon(
                      Icons.sunny,
                      size: 30,
                    )
                  : widget.task.type == TaskType.afternoon
                      ? const Icon(
                          Icons.work,
                          size: 30,
                        )
                      : const Icon(
                          Icons.nightlight_outlined,
                          size: 30,
                        ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.task.description,
                      style: TextStyle(
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      "Time: ${widget.task.timeAdded}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: widget.task.isCompleted,
                onChanged: (newValue) {
                  widget.completeTask(widget.task);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are You Sure?"),
          content: const Text("Do you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.deleteTask(widget.task);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }
}
