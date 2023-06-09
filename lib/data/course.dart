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
    Map<Object?, Object?> values = obj.value! as Map<Object?, Object?>;
    var parts = (values['subjects'] as String).trim().split(',');
    List<String> subjects = parts.map((e) => e).toList();

    try {
      Course course = Course(
        id: obj.key ?? '777',
        title: values['title'].toString(),
        description: values['description'].toString(),
        subjects: subjects,
        classes: values['classes'] as int,
        sampleExams: values['sampleExams'] as int,
        published: DateTime.parse(values['published'].toString()),
      );
      return course;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
