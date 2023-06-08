import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.subjects,
    required this.classes,
    required this.sampleExams,
    required this.published,
  });
  final String id;
  final String title;
  final String description;
  final List<String> subjects;
  final int classes;
  final int sampleExams;
  final DateTime published;

  static Course? fromDataSnapshot(DataSnapshot obj) {
    Map<String, dynamic> values = obj.value! as Map<String, dynamic>;
    var parts = (values['subjects'] as String).trim().split(',');
    List<String> subjects = parts.map((e) => e).toList();

    try {
      Course course = Course(
        id: obj.key ?? '777',
        title: values['title'],
        description: values['description'],
        subjects: subjects,
        classes: values['classes'],
        sampleExams: values['sampleExams'],
        published: DateTime.parse(values['published']),
      );
      return course;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
