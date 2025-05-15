import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  List<String> tasks = List.filled(9, '');
  List<bool> isChecked = List.filled(9, false);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks);
    prefs.setString('checked', jsonEncode(isChecked));
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');
    final savedChecks = prefs.getString('checked');

    if (savedTasks != null && savedChecks != null) {
      setState(() {
        tasks = savedTasks;
        isChecked = List<bool>.from(jsonDecode(savedChecks));
      });
    }
  }

  void setTask(int index) {
    _controller.text = tasks[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Task"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Your plan..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                tasks[index] = _controller.text.trim();
                isChecked[index] = false;
              });
              _controller.clear();
              saveState();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  bool checkBingo() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (isChecked[pattern[0]] &&
          isChecked[pattern[1]] &&
          isChecked[pattern[2]] &&
          tasks[pattern[0]].isNotEmpty &&
          tasks[pattern[1]].isNotEmpty &&
          tasks[pattern[2]].isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  void toggleCheck(int index) {
    if (tasks[index].isEmpty) return;

    setState(() {
      isChecked[index] = !isChecked[index];
    });

    saveState();

    if (checkBingo()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 Bingo!"),
          content: const Text("You've completed a line of tasks. Well done!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Awesome!"),
            ),
          ],
        ),
      );
    }
  }

  void clearTask(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Clear Task"),
        content: const Text("Do you want to clear this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks[index] = '';
                isChecked[index] = false;
              });
              saveState();
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Planner"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => tasks[index].isEmpty
                  ? setTask(index)
                  : toggleCheck(index),
              onLongPress: () => tasks[index].isNotEmpty
                  ? clearTask(index)
                  : null,
              child: Card(
                color: tasks[index].isEmpty
                    ? Colors.blue[100]
                    : (isChecked[index]
                        ? Colors.green[200]
                        : Colors.grey[100]),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Checkbox(
                        value: isChecked[index],
                        onChanged: tasks[index].isNotEmpty
                            ? (bool? value) => toggleCheck(index)
                            : null,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          tasks[index].isEmpty
                              ? "Write your plan"
                              : tasks[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isChecked[index]
                                ? Colors.green[800]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
