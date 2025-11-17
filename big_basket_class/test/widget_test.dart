import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Basket class',
      home: Scaffold(
        appBar: AppBar(title: const Text("Big Basket")),
        body: const Center(child: Text("Hello World")),
      ),
    );
  }
}