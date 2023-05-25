import 'package:flutter/material.dart';
import 'package:preptime/pages/Destinations/board_destination.dart';
import 'package:preptime/pages/Destinations/class_destination.dart';
import 'package:preptime/pages/Destinations/exam_destination.dart';

import '../pages/Destinations/home_destination.dart';

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
      icon: Icons.home,
      label: 'Home',
      route: '/',
      destination: HomeDestination()),
  Destination(
      icon: Icons.edit,
      label: 'Exams',
      route: '/exams',
      destination: ExamDestination()),
  Destination(
      icon: Icons.book,
      label: 'Courses',
      route: '/courses',
      destination: ClassDestination()),
  Destination(
      icon: Icons.leaderboard,
      label: 'Board',
      route: '/board',
      destination: BoardDestination()),
];