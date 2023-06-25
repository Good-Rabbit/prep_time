import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<ExamFragment>? _pastExams;

  bool isExamOngoing = false;
  Exam? ongoingExam;
  Classes? _selectedClass;
  DateTime? examTill;
  List<int> answers = [];
  List<int> correctAnswers = [];
  SharedPreferences? prefs;

  DatabaseReference? examsRef;

  Stream<QuerySnapshot<Map<String, dynamic>>>? pastExamsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      pastExamsSubscription;

  ExamProvider() {
    getPrefsAndCheck();
  }

  List<ExamFragment>? get pastExams => _pastExams;

  set pastExams(List<ExamFragment>? value) {
    _pastExams = value;
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

  retrieveRegisteredForExams() async {
    if (pastExamsStream == null) {
      pastExamsStream = FbProvider.store!
          .collection('users')
          .doc(AuthProvider.getUid())
          .collection('exams')
          .orderBy('start')
          .limitToLast(10)
          .snapshots();
      pastExamsSubscription = pastExamsStream!.listen((event) {
        _pastExams = event.docs
            .map((e) => ExamFragment.fromDocumentSnapshot(e))
            .toList();
        notifyListeners();
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

  completeOngoingExam() async {
    isExamOngoing = false;
    notifyListeners();
    await uploadOngoingExamResult();
    ongoingExam = null;
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

  Future<bool> registerForExam(Exam exam) async {
    try {
      FbProvider.store!
          .collection('users')
          .doc(AuthProvider.getUid())
          .collection('exams')
          .doc(exam.id)
          .set({
        'title': exam.title,
        'start': exam.start,
        'total': exam.questionIds.length,
        'complete': false,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> uploadOngoingExamResult() async {
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
        'total': ongoingExam!.questionIds.length,
        'start': ongoingExam!.start.toString(),
        'title': ongoingExam!.title,
        'answers': answers,
        'complete': true,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
