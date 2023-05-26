import 'package:flutter/material.dart';
import 'package:preptime/functions/time_formatter.dart';

import '../data/exam.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
  });

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      exam.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Chip(
                    label: Text(
                      exam.subjects[0],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (exam.subjects.length > 1)
                    Chip(
                      label: Text(
                        exam.subjects[1],
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (exam.subjects.length > 2)
                    Chip(
                      label: Text(
                        '+${(exam.subjects.length - 2).toString()}',
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (exam.start.isBefore(DateTime.now()))
                      const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 17,
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      getFormattedTime(exam.start),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${exam.duration.inMinutes.toString()} minutes',
                      style: const TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
