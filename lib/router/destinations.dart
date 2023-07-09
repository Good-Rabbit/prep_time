import 'package:flutter/material.dart';
import 'package:preptime/pages/routes/board_destination.dart';
import 'package:preptime/pages/routes/class_destination.dart';
import 'package:preptime/pages/routes/exam_destination.dart';

import '../pages/routes/home_destination.dart';

class Destination {
  const Destination(
      {required this.icon,
      required this.label,
      required this.route,
      required this.destination});

  final IconData icon;
  final String label;
  final String route;
  final Widget destination;
}

const List<Destination> destinations = [
  Destination(
      icon: Icons.home_rounded,
      label: 'Home',
      route: '/',
      destination: HomeDestination()),
  Destination(
      icon: Icons.edit_rounded,
      label: 'Exams',
      route: '/exams',
      destination: ExamDestination()),
  Destination(
      icon: Icons.book_rounded,
      label: 'Courses',
      route: '/courses',
      destination: ClassDestination()),
  Destination(
      icon: Icons.leaderboard_rounded,
      label: 'Stats',
      route: '/stats',
      destination: BoardDestination()),
];
