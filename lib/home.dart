import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 PLANTIC'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  
          crossAxisAlignment: CrossAxisAlignment.center,
     
          children: [
            
          

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Text(
                    'Welcome to your Motivation App!\nPlan, Tick, and Win Your Way to the Goal! 💪',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Colors.blue,
                            Colors.purpleAccent,
                          ],
                        ).createShader(
                          Rect.fromLTWH(
                            0.0,
                            0.0,
                            constraints.maxWidth,
                            700.0,
                          ),
                        ),
                    ),
                  );
                },
              ),
            ),
              Image.asset(
              'assets/images/welcome.jpg',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
