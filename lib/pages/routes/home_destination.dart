import 'package:flutter/material.dart';
import 'package:preptime/pages/fragments/course_list.dart';
import 'package:preptime/pages/fragments/live_exam_list.dart';
import 'package:preptime/pages/fragments/user_card.dart';
import 'package:preptime/services/intl.dart';

class HomeDestination extends StatefulWidget {
  const HomeDestination({super.key});

  @override
  State<HomeDestination> createState() => _HomeDestinationState();
}

class _HomeDestinationState extends State<HomeDestination> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // * User profile
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: UserCard(),
        ),
        // * Live exams list
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SelectableText(
            strings(context).liveExams,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const LiveExamList(),
        // * New courses list
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            strings(context).newCourses,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const CourseList(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
