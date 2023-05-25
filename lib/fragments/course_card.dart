import 'package:flutter/material.dart';
import 'package:preptime/data/course.dart';
import 'package:preptime/functions/time_formatter.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

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
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      course.description,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      course.subjects[0],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (course.subjects.length > 1)
                    Chip(
                      label: Text(
                        course.subjects[1],
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (course.subjects.length > 2)
                    Chip(
                      label: Text(
                        '+${(course.subjects.length - 2).toString()}',
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
            ],
          ),
        ),
      ),
    );
  }
}
