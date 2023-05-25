import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/functions/dynamic_padding_determiner.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/pages/four_o_four.dart';
import 'package:preptime/services/exam_provider.dart';
import 'package:preptime/services/intl.dart';
import 'package:provider/provider.dart';

class ExamDetails extends StatefulWidget {
  const ExamDetails({super.key, this.id = '', this.exam});

  final String id;
  final Exam? exam;

  @override
  State<ExamDetails> createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {
  @override
  Widget build(BuildContext context) {
    // * Determine page entry type
    // ** And show page accordingly
    if (widget.id == '' && widget.exam == null) {
      return const NotFound();
    } else if (widget.exam == null) {
      // ID not null
      // Get exam by id
      Exam exam = ExamProvider.sampleExams[ExamProvider.sampleExams
          .indexWhere((element) => element.id == widget.id)];
      return ExamDetailsFragment(exam: exam);
    } else {
      return ExamDetailsFragment(exam: widget.exam!);
    }
  }
}

class ExamDetailsFragment extends StatelessWidget {
  const ExamDetailsFragment({
    super.key,
    required this.exam,
  });

  final Exam exam;

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
        title: Text('${strings(context).liveExam} - ${exam.id}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: getDynamicPadding(context), vertical: 15),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Text(
              exam.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              exam.description,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 15, 15),
            child: Text(
              getFormattedTime(exam.start),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // * Check if any exam is ongoing
          // * Match examId
          // * For ongoing exam case with same examId + normal case
          if (!(context.watch<ExamProvider>().isExamOngoing &&
              context.read<ExamProvider>().ongoingExamId != exam.id))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 0),
              child: FilledButton.icon(
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
              context.read<ExamProvider>().ongoingExamId != exam.id)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 0),
              child: FilledButton.icon(
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
                        content: Text(
                            '${strings(context).examId} - ${ExamProvider.sampleExams[ExamProvider.sampleExams.indexWhere((element) => element.id == context.read<ExamProvider>().ongoingExamId)].id}'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(strings(context).ok),
                          ),
                          FilledButton(
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
                                extra: ExamProvider.sampleExams[ExamProvider
                                    .sampleExams
                                    .indexWhere((element) =>
                                        element.id ==
                                        context
                                            .read<ExamProvider>()
                                            .ongoingExamId)],
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