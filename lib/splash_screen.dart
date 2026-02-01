import 'dart:async';

import 'package:flutter/material.dart';

import 'todo_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TodoListPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle_outline,
              size: 90,
              color: Colors.pinkAccent,
            ),
            SizedBox(height: 20),
            Text(
              "Todo App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }
}
