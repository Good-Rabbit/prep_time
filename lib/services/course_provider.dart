import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:preptime/data/course.dart';
import 'package:preptime/services/firebase_provider.dart';

class CourseProvider with ChangeNotifier {
  List<Course>? _courses;
  DatabaseReference? coursesRef;

  retrieveCourses() async {
    if (coursesRef == null) {
      coursesRef = FbProvider.rtdb!.ref('courses');
      coursesRef!.limitToLast(10).onValue.listen(
        (event) {
          _courses = [];
          for (final exam in event.snapshot.children) {
            _courses!.add(Course.fromDataSnapshot(exam)!);
          }
          notifyListeners();
        },
      ).onError((e) {
        log(e.toString());
      });
    }
  }

  List<Course>? getCourses() {
    return _courses;
  }

  Future<Course?> getCourseById(String id) async {
    final snapshot = await coursesRef!.child(id).get();
    return Course.fromDataSnapshot(snapshot);
  }
}
