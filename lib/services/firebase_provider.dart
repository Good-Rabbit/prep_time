import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:preptime/data/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbProvider with ChangeNotifier {
  // * Firebase product instances
  // *
  FirebaseApp appInUse;
  static FirebaseFirestore? store;
  static FirebaseDatabase? rtdb;
  List<FirebaseOptions> options = const [
    FirebaseOptions(
      apiKey: 'AIzaSyDmYBmY0ibtQ-5AsPKk-_QwS2IjBYfTW84',
      appId: '1:463199041980:web:b5bdda4c4f358e7919d3b9',
      messagingSenderId: '463199041980',
      projectId: 'admission-preptime',
    ),
    FirebaseOptions(
      apiKey: 'AIzaSyAYXVHmfeOlXC1cl8mu_OxOfQXcpqbTYSo',
      appId: '1:888949572912:web:a8dd3ebb6a35d098e834f5',
      messagingSenderId: '888949572912',
      projectId: 'cadet-coaching-preptime',
    )
  ];

  FbProvider({required this.appInUse});

  // * Set Firestore and Realtime database instances
  setDbs() {
    store = FirebaseFirestore.instanceFor(app: appInUse);
    rtdb = FirebaseDatabase.instanceFor(app: appInUse);
    log('dbs instanciated');
  }

  setInstanceFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Classes? selectedClass =
        Classes.fromString(prefs.getString('selectedClass') ?? '');
    if (selectedClass != null) {
      setInstance(selectedClass);
    }
  }

  // * Initialize Firebase instances based on selected calss
  setInstance(Classes selectedClass) async {
    // TODO implement selected firebase
    switch (selectedClass.key) {
      case 1:
        // ? keep default app for 1
        try {
          setDbs();
        } catch (e) {
          log(e.toString());
        }
        break;
      case 2:
        try {
          appInUse = await Firebase.initializeApp(options: options[0]);
          setDbs();
        } catch (e) {
          log(e.toString());
        }
        break;
      case 3:
        try {
          appInUse = await Firebase.initializeApp(options: options[1]);
          setDbs();
        } catch (e) {
          log(e.toString());
        }
        break;
    }
  }
}
