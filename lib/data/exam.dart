import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.questionIds,
    required this.subjects,
    required this.topics,
    required this.start,
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
    Map<Object?, Object?> values = obj.value! as Map<Object?, Object?>;
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
        title: values['title'].toString(),
        description: values['description'].toString(),
        questionIds: ids,
        start: DateTime.parse(values['start'].toString()),
        subjects: subjects,
        topics: topics,
        duration: Duration(minutes: values['duration'] as int),
      );
      return exam;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  String toString() {
    String quids = '';
    for (var e in questionIds) {
      quids += '${e.$1},${e.$2}~';
    }
    quids = quids.substring(0, (quids.length - 1));
    String subs = '';
    for (var e in subjects) {
      subs += '$e,';
    }
    subs = subs.substring(0, (subs.length - 1));
    String tops = '';
    for (var e in topics) {
      tops += '$e,';
    }
    tops = tops.substring(0, (tops.length - 1));
    return '$id..$title..$description..$quids..$subs..$tops..${start.toString()}..${duration.inMinutes.toString()}';
  }

  static Exam? parse(String? string) {
    if (string == null) {
      return null;
    }
    final parts = string.split('..');

    List<String> joints = parts[3].trim().split('~');
    List<(String, String)> qids = [];
    for (var element in joints) {
      final parts = element.trim().split(',');
      qids.add((parts[0], parts[1]));
    }
    List<String> subjects = parts[4].trim().split(',').map((e) => e).toList();
    List<String> topics = parts[5].trim().split(',').map((e) => e).toList();

    return Exam(
      id: parts[0],
      title: parts[1],
      description: parts[2],
      questionIds: qids,
      subjects: subjects,
      topics: topics,
      start: DateTime.parse(parts[6]),
      duration: Duration(
        minutes: int.parse(parts[7]),
      ),
    );
  }
}

class ExamFragment {
  final String examId;
  final String title;
  final DateTime start;
  final bool complete;
  final int total;
  List<int>? answers;
  int? marks;

  ExamFragment({
    required this.examId,
    required this.title,
    required this.complete,
    required this.total,
    required this.start,
    this.answers,
    this.marks,
  });

  static ExamFragment fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<int> answers = [];
    answers = (snapshot.data()['answers'] as List<dynamic>)
        .map((e) => e as int)
        .toList();

    return ExamFragment(
      examId: snapshot.id,
      title: snapshot.data()['title'] as String,
      total: snapshot.data()['total'] as int,
      start: DateTime.parse(snapshot.data()['start'] as String),
      complete: snapshot.data()['complete'] as bool,
      answers: answers,
      marks: snapshot.data()['marks'] as int,
    );
  }
}
