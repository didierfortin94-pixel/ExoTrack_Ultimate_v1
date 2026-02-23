import 'package:coachpulse/core/app_strings.dart';
import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = stringsOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.today)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(loc.sessionOfDay),
              subtitle: const Text('Lower Body Strength · 60 min'),
              trailing: FilledButton(
                onPressed: () {},
                child: Text(loc.completeSession),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
