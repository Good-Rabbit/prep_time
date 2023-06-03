import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/fragments/course_card.dart';
import 'package:preptime/services/course_provider.dart';
import 'package:provider/provider.dart';

class CourseList extends StatefulWidget {
  const CourseList({
    super.key,
  });

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  checkExams() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          checkExams();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkExams();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: context.watch<CourseProvider>().getCourses().map((e) {
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: Theme.of(context).colorScheme.primary,
            child: CourseCard(course: e),
            onTap: () {
              context.go('/course/${e.id}');
            },
          );
        }).toList(),
      ),
    );
  }
}
