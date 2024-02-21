import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/constants/color.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/constants/new_task_type.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key, required this.addNewTask})
      : super(key: key);

  final void Function(Task newTask) addNewTask;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TaskType taskType = TaskType.morning;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: deviceWidth,
                height: deviceHeight / 10,
                color: Colors.black,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Add New Task",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 10), child: Text("Task Title")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Categories"),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text("Category Selected"),
                          ),
                        );
                        setState(() {
                          taskType = TaskType.morning;
                        });
                      },
                      child: const Icon(
                        Icons.sunny,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text("Category Selected"),
                          ),
                        );
                        setState(() {
                          taskType = TaskType.evening;
                        });
                      },
                      child: const Icon(
                        Icons.nightlight_outlined,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text("Category Selected"),
                          ),
                        );
                        setState(() {
                          taskType = TaskType.afternoon;
                        });
                      },
                      child: const Icon(
                        Icons.work,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Time"),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 170),
                            child: TextField(
                              controller: timeController,
                              decoration: const InputDecoration(
                                  filled: true, fillColor: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Note"),
              ),
              SizedBox(
                height: 300,
                child: TextField(
                  controller: descriptionController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                      filled: true, fillColor: Colors.white, isDense: true),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String selectedTime = timeController.text;
                  Task newTask = Task(
                    id: 0,
                    type: taskType,
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    timeAdded: selectedTime,
                  );
                  widget.addNewTask(newTask);
                  Navigator.pop(context);
                },
                child: const Text("Save Task"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
