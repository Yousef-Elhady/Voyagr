import 'package:flutter/material.dart';

class Logotext extends StatelessWidget {
  final String title;
  final double fontzs;
  const Logotext({super.key, required this.title, this.fontzs = 28.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.deepOrangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: fontzs,
      ),
    );
  }
}
