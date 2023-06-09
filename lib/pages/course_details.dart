import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/data/course.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';
import 'package:preptime/pages/four_o_four.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/services/course_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:provider/provider.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key, this.id = '', this.course});

  final String id;
  final Course? course;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  @override
  Widget build(BuildContext context) {
    // * Check blank ID
    if (widget.id == '' && widget.course == null) {
      return const NotFound();
    } else {
      // * Get exam by id
      return context.watch<AuthProvider>().getCurrentUser() == null
          ? const AuthDialog(
              shouldPopAutomatically: false,
            )
          : FutureBuilder(
              future: context.read<CourseProvider>().getCourseById(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return CourseDetailsFragment(course: snapshot.data!);
                  } else {
                    return const NotFound();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
    }
  }
}

class CourseDetailsFragment extends StatelessWidget {
  const CourseDetailsFragment({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.go('/');
          },
        ),
        title: Text('${strings(context).course} - ${course.id}'),
        centerTitle: true,
      ),
      body: responsiveCourseDetailsPage(context),
    );
  }

  Widget responsiveCourseDetailsPage(BuildContext context) {
    if (isWideScreen(context)) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getDynamicPadding(context), vertical: 10),
        child: Row(
          children: [
            Expanded(child: CourseDetailsMainColumn(course: course)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: CourseDetailsSecondaryColumn(course: course),
            ),
          ],
        ),
      );
    }
    return CourseDetailsMainColumn(course: course);
  }
}

class CourseDetailsSecondaryColumn extends StatelessWidget {
  const CourseDetailsSecondaryColumn({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Text(
        //   'Subjects',
        //   style: Theme.of(context).textTheme.titleMedium,
        // ),
        // SizedBox(
        //   height: 50,
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: course.subjects
        //           .map(
        //             (e) => Padding(
        //               padding: const EdgeInsets.all(5.0),
        //               child: Chip(
        //                 label: Text(
        //                   e,
        //                 ),
        //               ),
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        Text(
          'Subjects',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ...course.subjects
            .map(
              (e) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: Text(
                  e,
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

class CourseDetailsMainColumn extends StatelessWidget {
  const CourseDetailsMainColumn({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: getDynamicPadding(context), vertical: 15),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Text(
            course.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
            course.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: course.subjects
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Chip(
                          label: Text(
                            e,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 15, 15),
          child: Row(
            children: [
              Text(
                getFormattedTime(course.published),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${course.classes} Classes',
                style: const TextStyle(
                  color: Colors.green,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
