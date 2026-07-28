import 'package:ai_travel/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          context.go(RouteNames.profile);
        },
        icon: Icon(Icons.next_plan),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Center(
          child: Text("Home Page ", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
