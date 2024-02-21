import 'package:flutter/material.dart';
import 'package:todo/Pages/new_task.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/database.dart';
import 'package:todo/new_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<Task> tasks = [];
  List<Task> completed = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await DatabaseHelper().getTasks();
    completed = tasks.where((task) => task.isCompleted).toList();
    tasks.removeWhere((task) => task.isCompleted);
    setState(() {});
  }

  void deleteTask(Task task) async {
    await DatabaseHelper().deleteTask(task.id);
    _loadTasks();
  }

  void deleteCompletedTask(Task task) async {
    await DatabaseHelper().deleteTask(task.id);
    _loadTasks();
  }

  void addNewTask(Task newTask) async {
    await DatabaseHelper().insertTask(newTask);
    _loadTasks();
  }

  void completeTask(Task task) async {
    task.isCompleted = !task.isCompleted;
    await DatabaseHelper().updateTask(task);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = '${now.day}/${now.month}/${now.year}';
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: width,
              height: height / 4,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      '$date',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "To Do Best",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Item(
                        task: tasks[index],
                        deleteTask: deleteTask,
                        completeTask: completeTask,
                      );
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: completed.length,
                    itemBuilder: (context, index) {
                      return Item(
                        task: completed[index],
                        deleteTask: deleteCompletedTask,
                        completeTask: completeTask,
                      );
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNewTaskScreen(
                          addNewTask: addNewTask,
                        )));
              },
              child: const Text("Add New Task"),
            )
          ],
        ),
      ),
    );
  }
}
