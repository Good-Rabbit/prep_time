import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/functions/number_translator.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';
import 'package:preptime/pages/four_o_four.dart';
import 'package:preptime/pages/login.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:provider/provider.dart';

class ExamDetails extends StatefulWidget {
  const ExamDetails({super.key, required this.id});

  final String id;

  @override
  State<ExamDetails> createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {
  @override
  Widget build(BuildContext context) {
    // * Blank ID check
    if (widget.id == '') {
      return const NotFound();
    } else {
      // * Get exam by id
      return FutureBuilder(
        future: context.read<ExamProvider>().getExamById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ExamDetailsFragment(exam: snapshot.data!);
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

class ExamDetailsFragment extends StatefulWidget {
  const ExamDetailsFragment({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  State<ExamDetailsFragment> createState() => _ExamDetailsFragmentState();
}

class _ExamDetailsFragmentState extends State<ExamDetailsFragment> {
  @override
  void initState() {
    super.initState();
  }

  ticker() {
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          ticker();
        });
      }
    });
  }

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
        title: Text('${strings(context).liveExam} - ${widget.exam.id}'),
        centerTitle: true,
      ),
      body: context.watch<AuthProvider>().getCurrentUser() == null
          ? const AuthDialog(
              shouldPopAutomatically: false,
            )
          : responsiveExamDetailsPage(context),
    );
  }

  Widget responsiveExamDetailsPage(BuildContext context) {
    if (isWideScreen(context)) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getDynamicPadding(context), vertical: 10),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(child: ExamDetailsMainColumn(exam: widget.exam)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ExamDetailsSecondaryColumn(exam: widget.exam),
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
        child: ExamDetailsMainColumn(exam: widget.exam));
  }
}

class ExamDetailsSecondaryColumn extends StatelessWidget {
  const ExamDetailsSecondaryColumn({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Subjects',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: exam.subjects
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
        const SizedBox(
          height: 5,
        ),
        Text(
          'Topics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ...exam.topics
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

class ExamDetailsMainColumn extends StatelessWidget {
  const ExamDetailsMainColumn({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              exam.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              exam.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (!isWideScreen(context)) ExamDetailsSecondaryColumn(exam: exam),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 15, 15),
            child: Row(
              children: [
                Text(
                  strings(context).localeName == 'bn'
                      ? translateEnglishNumbers(getFormattedTime(exam.start))
                      : getFormattedTime(exam.start),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${strings(context).localeName == 'bn' ? translateEnglishNumbers(exam.duration.inMinutes.toString()) : exam.duration.inMinutes.toString()} ${strings(context).minutes}',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // * Check if any exam is ongoing
          // * Match examId
          // * For ongoing exam case with same examId + normal case
          if (!(context.watch<ExamProvider>().isExamOngoing &&
                      context.read<ExamProvider>().ongoingExam!.id !=
                          exam.id) &&
                  context.watch<ExamProvider>().isExamOngoing == false
              ? true
              : context
                  .watch<ExamProvider>()
                  .ongoingExam!
                  .start
                  .add(context.watch<ExamProvider>().ongoingExam!.duration)
                  .isAfter(DateTime.now()))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 0),
              child: ElevatedButton.icon(
                onPressed: exam.start.isAfter(DateTime.now())
                    ? null
                    : () {
                        context.push('/test_taker', extra: exam);
                        // * Set exam ongoing state to true and store exam id
                        context.read<ExamProvider>().setExamOngoing(exam);
                      },
                icon: const Icon(Icons.edit_rounded),
                label: Text(strings(context).takeTest),
              ),
            ),
          // * Check if any exam is ongoing
          // * Match examId
          // * For ongoing exam case with different examId
          if (context.watch<ExamProvider>().isExamOngoing &&
              context.read<ExamProvider>().ongoingExam!.id != exam.id)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 0),
              child: ElevatedButton.icon(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  iconColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(strings(context).examOngoing),
                        content:
                            Text('${strings(context).examId} - ${exam.id}'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(strings(context).ok),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red),
                              iconColor: MaterialStatePropertyAll(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                              context.pop();
                              context.push(
                                '/test_taker',
                                extra: exam,
                              );
                            },
                            child: Text(strings(context).run),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.dangerous_rounded),
                label: Text(strings(context).examOngoing),
              ),
            ),
        ],
      ),
    );
  }
}
