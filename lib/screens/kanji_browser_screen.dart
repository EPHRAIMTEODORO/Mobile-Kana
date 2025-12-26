import 'package:flutter/material.dart';

class KanjiBrowserScreen extends StatelessWidget {
  const KanjiBrowserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanji Browser'),
      ),
      body: const Center(
        child: Text('Kanji Browser Screen - Implementation in progress'),
      ),
    );
  }
}
