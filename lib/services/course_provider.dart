import 'package:flutter/material.dart';
import 'package:preptime/data/course.dart';

class CourseProvider with ChangeNotifier {
  static List<Course> sampleCourses = [
    Course(
      id: '1',
      title:
          'Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 ',
      description:
          'Sample course description Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 Sample course title 1 ',
      subjects: ['BNG', 'ENG', 'MATH'],
      classes: 15,
      sampleExams: 3,
      published: DateTime.now(),
    ),
    Course(
      id: '2',
      title: 'Sample course title 1 ',
      description: 'Sample course description ',
      subjects: ['MATH'],
      classes: 10,
      sampleExams: 7,
      published: DateTime.now(),
    ),
    Course(
      id: '4',
      title: 'Sample course title 1 ',
      description: 'Sample course description ',
      subjects: ['ENG', 'MATH'],
      classes: 10,
      sampleExams: 3,
      published: DateTime.now(),
    ),
    Course(
      id: '4',
      title: 'Sample course title 1 ',
      description: 'Sample course description ',
      subjects: ['BNG', 'ENG', 'MATH', 'BGS', 'SCI'],
      classes: 10,
      sampleExams: 3,
      published: DateTime.now(),
    ),
  ];

  List<Course> getCourses() {
    // TODO implement : from firestore
    return getSampleCourses();
  }

  static List<Course> getSampleCourses() => sampleCourses;
}
