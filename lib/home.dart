import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Vertically center
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
          children: [
            Image.asset(
              'assets/images/welcome.jpg', // Replace with your image path
              height: 450,
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Welcome to your Motivation App!\nPlan, Tick, and Win Your Way to the Goal!💪',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
