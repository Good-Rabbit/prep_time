
import 'package:flutter/material.dart';

bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >
      MediaQuery.of(context).size.height * 0.8;
  }