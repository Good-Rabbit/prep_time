import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/functions/number_translator.dart';
import 'package:preptime/functions/time_formatter.dart';
import 'package:preptime/services/intl.dart';

class ParticipatingExamCard extends StatefulWidget {
  const ParticipatingExamCard({super.key, required this.examFragment});

  final ExamFragment examFragment;

  @override
  State<ParticipatingExamCard> createState() => _ParticipatingExamCardState();
}

class _ParticipatingExamCardState extends State<ParticipatingExamCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.examFragment.marks! / widget.examFragment.total < 0.4
          ? Colors.red
          : Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam - ${widget.examFragment.examId}',
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              widget.examFragment.title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.examFragment.complete) const Text('Ongoing'),
                if (widget.examFragment.complete)
                  Text(
                    'Marks - ${widget.examFragment.marks.toString()}/${widget.examFragment.total.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                Text(
                  strings(context).localeName == 'bn'
                      ? translateEnglishNumbers(
                          getFormattedTime(widget.examFragment.start))
                      : getFormattedTime(widget.examFragment.start),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
