import 'dart:math';

import 'package:flutter/material.dart';
import 'package:preptime/functions/wide_screen_determiner.dart';

double getDynamicPadding(BuildContext context) {
  return isWideScreen(context)
      ? pow(MediaQuery.of(context).size.width / 300, 3).toDouble()
      : 10;
}
