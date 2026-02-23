import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Calendar')),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (_, index) {
          return ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text('Day ${index + 1} session'),
            subtitle: const Text('Program instance planned'),
          );
        },
      ),
    );
  }
}
