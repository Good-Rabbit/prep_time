import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/pages/class_selector.dart';
import 'package:preptime/pages/course_details.dart';
import 'package:preptime/pages/exam_details.dart';
import 'package:preptime/pages/four_o_four.dart';
import 'package:preptime/pages/shell.dart';
import 'package:preptime/pages/test_taker.dart';
import 'package:preptime/router/destinations.dart';

// Using go_router for deep linking support
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFound(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => Shell(child: child),
      // Build routes from destinations
      routes: [
        ...destinations
            .map(
              (e) => GoRoute(
                path: e.route,
                pageBuilder: (context, state) =>
                    MaterialPage(child: e.destination),
                // builder: (context, state) => e.destination,
              ),
            )
            .toList(),
        GoRoute(
          path: '/exam/:id',
          pageBuilder: (context, state) => MaterialPage(
            child: ExamDetails(id: state.pathParameters['id'] ?? ''),
          ),
        ),
        GoRoute(
          path: '/course/:id',
          pageBuilder: (context, state) => MaterialPage(
            child: CourseDetails(id: state.pathParameters['id'] ?? ''),
          ),
        ),
        GoRoute(
          path: '/test_taker',
          pageBuilder: (context, state) => MaterialPage(
            child: TestTakerShell(exam: state.extra as Exam),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/class_selector',
      pageBuilder: (context, state) => const MaterialPage(
        child: ClassSelector(),
      ),
    ),
  ],
);
