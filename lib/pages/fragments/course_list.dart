import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/pages/fragments/course_card.dart';
import 'package:preptime/pages/fragments/loading_card.dart';
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
    if (context.watch<CourseProvider>().getCourses() == null) {
      // TODO loading
      return SizedBox(
        height: 275,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const LoadingCard();
          },
        ),
      );
    }
    return SizedBox(
      height: 270,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: context.watch<CourseProvider>().getCourses()!.map((e) {
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
