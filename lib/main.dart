
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'features/home/home_page.dart';
import 'features/workout/workouts_page.dart';
import 'features/coach/coach_page.dart';
import 'features/history/history_page.dart';
import 'features/profile/profile_page.dart';

void main() { runApp(const ExoTrackApp()); }

class ExoTrackApp extends StatefulWidget {
  const ExoTrackApp({super.key});
  @override
  State<ExoTrackApp> createState() => _ExoTrackAppState();
}

class _ExoTrackAppState extends State<ExoTrackApp> {
  int _tab = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExoTrack',
      debugShowCheckedModeBanner: false,
      theme: ExoTheme.dark(),
      home: Scaffold(
        body: IndexedStack(index: _tab, children: const [HomePage(), WorkoutsPage(), CoachPage(), HistoryPage(), ProfilePage()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Workouts'),
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Coach'),
            NavigationDestination(icon: Icon(Icons.timeline_outlined), selectedIcon: Icon(Icons.timeline), label: 'History'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: const Color(0xFF0F1216), indicatorColor: const Color(0xFF0D74D6).withOpacity(.15), elevation: 1,
        ),
      ),
    );
  }
}
