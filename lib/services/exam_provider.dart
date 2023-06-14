import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/data/classes.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamProvider with ChangeNotifier {
  // * Live exams
  List<Exam>? _exams;

  bool isExamOngoing = false;
  Exam? ongoingExam;
  Classes? _selectedClass;
  DateTime? examTill;
  List<int> answers = [];
  List<int> correctAnswers = [];
  SharedPreferences? prefs;

  DatabaseReference? examsRef;

  ExamProvider() {
    getPrefsAndCheck();
  }

  retrieveExams() async {
    if (examsRef == null) {
      examsRef = FbProvider.rtdb!.ref('exams');
      examsRef!.limitToLast(10).onValue.listen(
        (event) {
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
    // prefs!.clear();
    _selectedClass =
        Classes.fromString(prefs!.getString('selectedClass') ?? '');
    retrieveAndCheckExamStatus();
  }

  setOngoingExamAnswers(List<int> answers) async {
    prefs!.setStringList('answers${_selectedClass!.key}',
        answers.map((e) => e.toString()).toList());
    this.answers = answers;
  }

  resetOngoingExamAnswers() async {
    prefs!.remove('answers${_selectedClass!.key}');
    answers = [];
  }

  setExamOngoing(Exam exam) async {
    ongoingExam = exam;
    isExamOngoing = true;
    examTill = exam.start.add(exam.duration);
    Duration timeLeft = examTill!.difference(DateTime.now());
    Future.delayed(timeLeft, () => completeOngoingExam());
    storeExamStatus();
    notifyListeners();
  }

  completeOngoingExam() {
    uploadExamResult();
    ongoingExam = null;
    isExamOngoing = false;
    examTill = null;
    resetOngoingExamAnswers();
    storeExamStatus();
    notifyListeners();
  }

  storeExamStatus() async {
    // * Store exam status to storage

    prefs!.setBool('examOngoing${_selectedClass!.key}', isExamOngoing);
    prefs!.setString('exam${_selectedClass!.key}', ongoingExam!.toString());
    prefs!.setString('examTill${_selectedClass!.key}', examTill.toString());
  }

  retrieveAndCheckExamStatus() async {
    // * Get exam status from storage
    isExamOngoing =
        prefs!.getBool('examOngoing${_selectedClass!.key}') ?? false;
    ongoingExam = Exam.parse(prefs!.getString('exam${_selectedClass!.key}'));
    answers = (prefs!.getStringList('answers${_selectedClass!.key}') ?? [])
        .map((e) => int.parse(e))
        .toList();
    String till = prefs!.getString('examTill${_selectedClass!.key}') ?? '';
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

  List<Exam>? get exams {
    return _exams;
  }

  Future<List<Question>> getExamQuestions(Exam exam) async {
    List<Question> questions = [];
    for ((String id, String sub) qid in exam.questionIds) {
      await FbProvider.store!
          .collection(qid.$2)
          .doc(qid.$1)
          .get()
          .then((value) {
        if (value.exists) {
          questions.add(Question.fromDataSnapshot(value)!);
        }
      });
    }
    return questions;
  }

  Future<bool> uploadExamResult() async {
    int marks = 0;
    for (int i = 0; i < correctAnswers.length; i++) {
      if (answers[i] == correctAnswers[i]) {
        marks++;
      }
    }
    try {
      FbProvider.store!
          .collection('users')
          .doc(AuthProvider.getUid())
          .collection('exams')
          .doc(ongoingExam!.id)
          .set({
        'marks': marks,
        'title': ongoingExam!.title,
        'answers': answers,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
