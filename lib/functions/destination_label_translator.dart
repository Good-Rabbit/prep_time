
import 'package:flutter/material.dart';
import 'package:preptime/services/intl.dart';

String getTranslation(String text, BuildContext context) {
  String label = '';
  switch (text) {
    case 'Home':
      label = strings(context).home;
      break;
    case 'Exams':
      label = strings(context).exams;
      break;
    case 'Courses':
      label = strings(context).courses;
      break;
    case 'Board':
      label = strings(context).board;
      break;
    default:
      break;
  }

  return label;
}