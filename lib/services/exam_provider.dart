import 'package:flutter/material.dart';
import 'package:preptime/data/exam.dart';
import 'package:preptime/data/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamProvider with ChangeNotifier {
  static String time = DateTime(2023).toString();
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
  static List<Exam> sampleExams = [
    Exam(
      duration: const Duration(minutes: 1),
      id: "1",
      title:
          'Sample Exam 1Sample Exam 1Sample Exam 1Sample Exam 1Sample Exam 1Sample Exam 1',
      description:
          'Just a demo examJust Just a demo examJust Just a demo examJust Just a demo examJust a demo examJust a demo examJust a demo examJust a demo examJust a demo examJust a demo examJust a demo exam',
      questionIds: [
        ('1', 'eng', 6),
        ('2', 'bng', 7),
        ('1', 'eng', 6),
        ('2', 'bng', 7)
      ],
      subjects: [
        'BNG',
        'ENG',
        'MATH',
        'SCI',
        'BGS',
      ],
      topics: [
        'one',
        'two',
        'three',
        'one',
        'two',
        'three',
        'one',
        'two',
        'three'
      ],
      start: DateTime.now(),
    ),
    Exam(
      duration: const Duration(minutes: 5),
      id: "2",
      title: 'Sample Exam 2',
      description: 'Just a demo exam',
      questionIds: [
        ('1', 'eng', 6),
        ('2', 'bng', 7),
        ('3', 'eng', 6),
        ('4', 'bng', 7),
        ('5', 'eng', 6),
        ('6', 'bng', 7),
        ('7', 'eng', 6),
        ('8', 'bng', 7),
        ('1', 'eng', 6),
        ('2', 'bng', 7),
        ('3', 'eng', 6),
        ('4', 'bng', 7),
        ('5', 'eng', 6),
        ('6', 'bng', 7),
        ('7', 'eng', 6),
        ('8', 'bng', 7),
      ],
      subjects: ['Bengali', 'English', 'Math'],
      topics: [
        'one',
        'two',
        'three',
        'one',
        'two',
        'three',
        'one',
        'two',
        'three'
      ],
      start: DateTime.now(),
    ),
    Exam(
      duration: const Duration(minutes: 30),
      id: "3",
      title: 'Sample Exam 3',
      description: 'Just a demo exam',
      questionIds: [
        ('1', 'eng', 6),
        ('2', 'bng', 7),
        ('1', 'eng', 6),
        ('2', 'bng', 7)
      ],
      subjects: ['Bengali', 'English', 'Math'],
      topics: [
        'one',
        'two',
        'three',
        'one',
        'two',
        'three',
        'one',
        'two',
        'three'
      ],
      start: DateTime.now().add(const Duration(minutes: 10)),
    ),
    Exam(
      duration: const Duration(minutes: 30),
      id: "4",
      title: 'Sample Exam 4',
      description: 'Just a demo exam',
      questionIds: [
        ('1', 'eng', 6),
        ('2', 'bng', 7),
        ('1', 'eng', 6),
        ('2', 'bng', 7)
      ],
      subjects: ['Bengali', 'English', 'Math'],
      topics: [
        'one',
        'two',
        'three',
        'one',
        'two',
        'three',
        'one',
        'two',
        'three'
      ],
      start: DateTime.now(),
    ),
  ];

  bool isExamOngoing = false;
  String? ongoingExamId;
  DateTime? examTill;
  List<String> answers = [];
  SharedPreferences? prefs;

  ExamProvider() {
    getPrefsAndCheck();
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
    String? till = prefs!.getString('examTill');
    examTill = DateTime.tryParse(till!);
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

  List<Exam> getExams() {
    //TODO implement : from rtdb
    return getSampleExams();
  }

  Future<List<Question>> getExamQuestions(Exam exam) {
    List<Question> questions = [];
    for ((String id, String sub, int classNo) qid in exam.questionIds) {
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

  static List<Exam> getSampleExams() => sampleExams;

  static List<Question> getSampleQuestions() => sampleQuestions;
}
