import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.questionIds,
    required this.start,
    required this.subjects,
    required this.topics,
    required this.duration,
  });

  final String id;
  final String title;
  final String description;
  final List<(String id, String subject)> questionIds;
  final List<String> subjects;
  final List<String> topics;
  final DateTime start;
  final Duration duration;

  static Exam? fromDataSnapshot(DataSnapshot obj) {
    Map<String, dynamic> values = obj.value! as Map<String, dynamic>;
    final joints = (values['questionIds'] as String).trim().split('~');
    List<(String, String)> ids = [];
    for (var element in joints) {
      final parts = element.trim().split(',');
      ids.add((parts[0], parts[1]));
    }
    var parts = (values['subjects'] as String).trim().split(',');
    List<String> subjects = parts.map((e) => e).toList();
    parts = (values['topics'] as String).trim().split(',');
    List<String> topics = parts.map((e) => e).toList();

    try {
      Exam exam = Exam(
        id: obj.key ?? '777',
        title: values['title'],
        description: values['description'],
        questionIds: ids,
        start: DateTime.parse(values['start']),
        subjects: subjects,
        topics: topics,
        duration: Duration(minutes: values['duration']),
      );
      return exam;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
