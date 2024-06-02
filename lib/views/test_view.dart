import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Text("Hello, Flutter")
    );
  }
}