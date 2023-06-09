import 'package:flutter/material.dart';
import 'package:preptime/pages/fragments/course_list.dart';
import 'package:preptime/pages/fragments/live_exam_list.dart';
import 'package:preptime/pages/fragments/live_ticker.dart';
import 'package:preptime/pages/fragments/user_card.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:preptime/theme/theme.dart';
import 'package:provider/provider.dart';

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
          padding: EdgeInsets.all(5.0),
          child: UserCard(),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ongoing Exam:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (context.watch<ExamProvider>().isExamOngoing)
                  const LiveTicker(),
                if (!context.watch<ExamProvider>().isExamOngoing)
                  ElevatedButton.icon(
                    label: const SizedBox(
                      width: 40,
                      child: Text(
                        'None',
                      ),
                    ),
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(themeColorWithAlpha),
                    ),
                    icon: const Icon(
                      Icons.edit_rounded,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // * Live exams list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            strings(context).liveExams,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const LiveExamList(),
        // * New courses list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            strings(context).newCourses,
            style: Theme.of(context).textTheme.titleMedium,
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
