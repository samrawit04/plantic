import 'package:flutter/material.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  List<String> tasks = List.filled(9, '');
  List<bool> isChecked = List.filled(9, false);
  final TextEditingController _controller = TextEditingController();

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

  void toggleCheck(int index) {
    if (tasks[index].isEmpty) return; // Don't allow checking empty task

    setState(() {
      isChecked[index] = !isChecked[index];
    });

    final winningPattern = getWinningPattern();
    if (winningPattern != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 Bingo!"),
          content: const Text("You've completed a line of tasks. Well done!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  for (var i in winningPattern) {
                    tasks[i] = '';
                    isChecked[i] = false;
                  }
                });
              },
              child: const Text("Clear Winning Tasks"),
            ),
          ],
        ),
      );
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
