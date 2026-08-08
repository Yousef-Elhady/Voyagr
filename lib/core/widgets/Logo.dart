import 'package:flutter/material.dart';

class Logotext extends StatelessWidget {
  final String title;
  const Logotext({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
    );
  }
}
