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
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');
    final savedChecked = prefs.getString('checked');

    if (savedTasks != null) {
      tasks = savedTasks;
    }
    if (savedChecked != null) {
      isChecked = List<bool>.from(jsonDecode(savedChecked));
    }

    setState(() {});
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
    await prefs.setString('checked', jsonEncode(isChecked));
  }

  void setTask(int index) {
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
              if (_controller.text.trim().isNotEmpty) {
                setState(() {
                  tasks[index] = _controller.text;
                  isChecked[index] = false;
                });
                saveData();
              }
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  List<int>? getWinningPattern() {
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
          isChecked[pattern[2]]) {
        return pattern;
      }
    }
    return null;
  }

  bool _isDialogOpen = false;

  void toggleCheck(int index) {
    if (tasks[index].isEmpty) return;

    setState(() {
      isChecked[index] = !isChecked[index];
    });

    // Only check for a win if the box was just checked (not unchecked)
    if (isChecked[index]) {
      Future.microtask(() {
        final winningPattern = getWinningPattern();
        if (winningPattern != null && !_isDialogOpen) {
          _isDialogOpen = true;

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("🎉 You Win!"),
              content:
                  const Text("You completed a line of tasks. Great job!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      for (var i in winningPattern) {
                        tasks[i] = '';
                        isChecked[i] = false;
                      }
                      _isDialogOpen = false;
                    });
                    saveData();
                  },
                  child: const Text("Clear Winning Tasks"),
                ),
              ],
            ),
          );
        } else {
          saveData();
        }
      });
    } else {
      // If user unchecked, just save
      saveData();
    }
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
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => tasks[index].isEmpty
                  ? setTask(index)
                  : toggleCheck(index),
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
