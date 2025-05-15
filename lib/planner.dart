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
              setState(() {
                tasks[index] = _controller.text;
                isChecked[index] = false;
              });
              _controller.clear();
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
          isChecked[pattern[2]]) {
        return true;
      }
    }
    return false;
  }

  void toggleCheck(int index) {
    setState(() {
      isChecked[index] = !isChecked[index];
    });

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
                color: tasks[index].isEmpty ? Colors.blue[100] : (isChecked[index] ? Colors.green[200] : Colors.grey[100]),
                child: Stack(
                  children: [
                    // Checkbox at the top right
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Checkbox(
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          toggleCheck(index);
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        tasks[index].isEmpty ? "Write your plan" : tasks[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isChecked[index] ? Colors.green[800] : Colors.black,
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
