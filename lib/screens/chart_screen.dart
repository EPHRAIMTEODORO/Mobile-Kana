import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kana Chart'),
      ),
      body: const Center(
        child: Text('Kana Chart Screen - Implementation in progress'),
      ),
    );
  }
}
