import 'package:flutter/material.dart';
import 'package:preptime/fragments/course_card.dart';
import 'package:preptime/fragments/live_exam_list.dart';
import 'package:preptime/services/course_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:provider/provider.dart';

class HomeDestination extends StatefulWidget {
  const HomeDestination({super.key});

  @override
  State<HomeDestination> createState() => _HomeDestinationState();
}

class _HomeDestinationState extends State<HomeDestination> {
  @override
  Widget build(BuildContext context) {
    // ! SizedBox is required to fix height with ListView
    // ! Listview takes full height without a column
    return ListView(
      children: [
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
        SizedBox(
          height: 270,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: context
                .watch<CourseProvider>()
                .getCourses()
                .map(
                  (e) => CourseCard(
                    course: e,
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
