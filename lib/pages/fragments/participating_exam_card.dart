import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam - ${widget.examFragment.examId}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.examFragment.title),
            if (widget.examFragment.complete)
              Text('Marks - ${widget.examFragment.marks.toString()}/${widget.examFragment.total.toString()}'),
            if (!widget.examFragment.complete) const Text('Ongoing'),
          ],
        ),
      ),
    );
  }
}
