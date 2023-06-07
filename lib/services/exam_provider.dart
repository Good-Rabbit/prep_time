import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamProvider with ChangeNotifier {
  static List<Question> sampleQuestions = const [
    Question(
      id: "1",
      content:
          'What is your name What is your name What is your name What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "2",
      content: 'What is your name',
      options: ['Some', 'Take', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "3",
      content: 'What is your name',
      options: ['Some', 'None', 'BT', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "4",
      content: 'What is your name',
      options: ['Wifi', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "5",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "6",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "7",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "8",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "9",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
    Question(
      id: "10",
      content: 'What is your name',
      options: ['Some', 'None', 'All', 'Where'],
      correctIndex: 2,
      difficulty: 1,
      time: 60,
    ),
  ];

  static List<Exam>? _exams;

  bool isExamOngoing = false;
  bool gotData = false;
  String? ongoingExamId;
  DateTime? examTill;
  List<String> answers = [];
  SharedPreferences? prefs;

  DatabaseReference? examsRef;

  ExamProvider() {
    getPrefsAndCheck();
  }

  retrieveExams() {
    if (!gotData) {
      examsRef = FbProvider.rtdb!.ref('exams');
      examsRef!.limitToLast(10).onValue.listen(
        (event) {
          gotData = true;
          _exams = [];
          for (final exam in event.snapshot.children) {
            _exams!.add(Exam.fromDataSnapshot(exam)!);
          }
          notifyListeners();
        },
      ).onError((e) {
        log(e.toString());
      });
    }
  }

  Future<Exam?> getExamById(String id) async {
    final snapshot = await examsRef!.child(id).get();
    return Exam.fromDataSnapshot(snapshot);
  }

  getPrefsAndCheck() async {
    prefs = await SharedPreferences.getInstance();
    retrieveAndCheckExamStatus();
  }

  setOngoingExamAnswers(List<String> answers) async {
    prefs!.setStringList('answers', answers);
    this.answers = answers;
  }

  resetOngoingExamAnswers() async {
    prefs!.remove('answers');
    answers = [];
  }

  setExamOngoing(Exam exam) async {
    ongoingExamId = exam.id;
    isExamOngoing = true;
    examTill = exam.start.add(exam.duration);
    Duration timeLeft = examTill!.difference(DateTime.now());
    Future.delayed(timeLeft, () => completeOngoingExam());
    storeExamStatus();
    notifyListeners();
  }

  completeOngoingExam() {
    ongoingExamId = null;
    isExamOngoing = false;
    examTill = null;
    resetOngoingExamAnswers();
    storeExamStatus();
    notifyListeners();
  }

  storeExamStatus() async {
    // * Store exam status to storage

    prefs!.setBool('examOngoing', isExamOngoing);
    prefs!.setString('examId', ongoingExamId ?? '');
    prefs!.setString('examTill', examTill.toString());
  }

  retrieveAndCheckExamStatus() async {
    // * Get exam status from storage
    isExamOngoing = prefs!.getBool('examOngoing') ?? false;
    ongoingExamId = prefs!.getString('examId');
    answers = prefs!.getStringList('answers') ?? [];
    String till = prefs!.getString('examTill') ?? '';
    examTill = DateTime.tryParse(till);
    if (examTill != null && isExamOngoing) {
      if (examTill!.isBefore(DateTime.now())) {
        completeOngoingExam();
      } else {
        Duration timeLeft = examTill!.difference(DateTime.now());
        Future.delayed(timeLeft, completeOngoingExam);
      }
    }
    notifyListeners();
  }

  List<Exam>? getExams() {
    return _exams;
  }

  Future<List<Question>> getExamQuestions(Exam exam) {
    List<Question> questions = [];
    for ((String id, String sub) qid in exam.questionIds) {
      // TODO get questions with id from db
      // O(nlogn) when from firestore
      // O(mn) now
      for (Question question in sampleQuestions) {
        if (question.id == qid.$1) {
          questions.add(question);
          break;
        }
      }
    }
    return Future.delayed(const Duration(milliseconds: 0))
        .then((value) => questions);
  }

  static List<Question> getSampleQuestions() => sampleQuestions;
}
