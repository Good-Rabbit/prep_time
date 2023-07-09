import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:preptime/auth/auth.dart';
import 'package:preptime/data/answers.dart';
import 'package:preptime/data/classes.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:preptime/services/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamProvider with ChangeNotifier {
  // * Live exams
  List<Exam>? _exams;
  List<ExamFragment>? pastExams;

  bool isExamOngoing = false;
  Exam? ongoingExam;
  Classes? _selectedClass;
  DateTime? examTill;
  List<Question> questions = [];
  List<Answer> answers = [];
  List<int> correctAnswersIndexes = [];
  SharedPreferences? prefs;

  DatabaseReference? examsRef;

  Stream<QuerySnapshot<Map<String, dynamic>>>? pastExamsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      pastExamsSubscription;

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
        pastExams = event.docs
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
    retrieveAndCheckExamStatusFromStorage();
  }

  setOngoingExamAnswers(List<Answer> answers) async {
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
    storeExamStatusToStorage();
    notifyListeners();
  }

  storeExamStatusToStorage() async {
    prefs!.setBool('examOngoing${_selectedClass!.key}', isExamOngoing);
    if (!isExamOngoing) {
      prefs!.remove('exam${_selectedClass!.key}');
      prefs!.remove('examTill${_selectedClass!.key}');
    } else {
      prefs!.setString('exam${_selectedClass!.key}', ongoingExam!.toString());
      prefs!.setString('examTill${_selectedClass!.key}', examTill.toString());
    }
  }

  retrieveAndCheckExamStatusFromStorage() async {
    isExamOngoing =
        prefs!.getBool('examOngoing${_selectedClass!.key}') ?? false;
    ongoingExam = Exam.parse(prefs!.getString('exam${_selectedClass!.key}'));
    answers =
        (prefs!.getStringList('answers${_selectedClass!.key}') ?? []).map((e) {
      return Answer.fromString(e);
    }).toList();
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
    for ((String id, String sub) qid in exam.questionIds) {
      await FbProvider.store!
          .collection(qid.$2)
          .doc(qid.$1)
          .get()
          .then((value) {
        if (value.exists) {
          questions.add(
              Question.fromDataSnapshot(snapshot: value, subject: qid.$2)!);
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

  completeOngoingExam() async {
    isExamOngoing = false;
    notifyListeners();
    // * Wait for processes before uploading exam and resetting variables
    await Future.delayed(const Duration(seconds: 1), uploadOngoingExamResult);
    ongoingExam = null;
    examTill = null;
    resetOngoingExamAnswers();
    resetPerQuestionTimers();
    storeExamStatusToStorage();
    notifyListeners();
  }

  resetPerQuestionTimers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var question in questions) {
      prefs.remove(question.subject + question.id);
    }
  }

  Future<bool> uploadOngoingExamResult() async {
    int marks = 0;
    for (int i = 0; i < correctAnswersIndexes.length; i++) {
      if (answers[i].selected == correctAnswersIndexes[i]) {
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
        'start': ongoingExam!.start,
        'title': ongoingExam!.title,
        'answers': answers.map((e) => e.selected).toList(),
        'complete': true,
      });

      // TODO Calculate and upload proficiency
      Map<String, int> topicWiseProficiencies = {};
      Map<String, int> topicQuestionCount = {};
      Map<String, int> topicTotalProficiency = {};
      Set<String> topics = {};

      for (int i = 0; i < questions.length; i++) {
        for (var t in questions[i].topics) {
          topics.add(t);
          topicQuestionCount[t] = (topicQuestionCount[t] ?? 0) + 1;
        }
        for (var t in answers[i].topics) {
          topicTotalProficiency[t] =
              (topicTotalProficiency[t] ?? 0) + answers[i].proficiencyIndex;
        }
      }

      for (var t in topics) {
        topicWiseProficiencies[t] =
            topicTotalProficiency[t]! ~/ topicQuestionCount[t]!;
      }

      FbProvider.store!
          .collection('users')
          .doc(AuthProvider.getUid())
          .collection('stats')
          .doc(ongoingExam!.start.add(ongoingExam!.duration).toString())
          .set(topicWiseProficiencies);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
