import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

List<Destination> destinations = const [
  Destination(
    icon: Icons.home_rounded,
    label: 'Home',
    route: '/',
  ),
  Destination(
    icon: Icons.edit_rounded,
    label: 'Exams',
    route: '/exams',
  ),
  Destination(
    icon: Icons.book_rounded,
    label: 'Courses',
    route: '/courses',
  ),
  Destination(
    icon: Icons.leaderboard_rounded,
    label: 'Stats',
    route: '/stats',
  ),
];
