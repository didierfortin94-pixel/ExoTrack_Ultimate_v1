import 'package:coachpulse/features/auth/login_page.dart';
import 'package:coachpulse/features/calendar/calendar_page.dart';
import 'package:coachpulse/features/dashboard/dashboard_page.dart';
import 'package:coachpulse/features/privacy/privacy_page.dart';
import 'package:coachpulse/features/today/today_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginPage()),
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/today', builder: (_, __) => const TodayPage()),
        GoRoute(path: '/calendar', builder: (_, __) => const CalendarPage()),
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
        GoRoute(path: '/privacy', builder: (_, __) => const PrivacyPage()),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = switch (location) {
      '/today' => 0,
      '/calendar' => 1,
      '/dashboard' => 2,
      '/privacy' => 3,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              context.go('/today');
            case 1:
              context.go('/calendar');
            case 2:
              context.go('/dashboard');
            case 3:
              context.go('/privacy');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.privacy_tip), label: 'Privacy'),
        ],
      ),
    );
  }
}
