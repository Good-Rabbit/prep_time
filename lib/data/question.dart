import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.subject,
    required this.difficulty,
    required this.time,
    required this.topics,
  });

  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String subject;
  final int difficulty;
  final int time;
  final List<String> topics;

  static Question? fromDataSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required String subject,
  }) {
    List<String> options = snapshot
        .data()!['opts']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim()
        .split(',')
        .map((e) => e.trim())
        .toList();
    List<String> topics = snapshot
        .data()!['tops']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim()
        .split(',')
        .map((e) => e.trim())
        .toList();
    final question = Question(
      id: snapshot.id,
      question: snapshot.data()!['ques'] as String,
      options: options,
      subject: subject,
      correctIndex: snapshot.data()!['ans'] as int,
      difficulty: snapshot.data()!['lvl'] as int,
      time: snapshot.data()!['time'] as int,
      topics: topics,
    );
    return question;
  }
}
