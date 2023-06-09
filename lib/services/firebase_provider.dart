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
      apiKey: 'AIzaSyAYXVHmfeOlXC1cl8mu_OxOfQXcpqbTYSo',
      appId: '1:888949572912:web:a8dd3ebb6a35d098e834f5',
      messagingSenderId: '888949572912',
      storageBucket: "cadet-coaching-preptime.appspot.com",
      databaseURL:
          "https://cadet-coaching-preptime-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: 'cadet-coaching-preptime',
    ),
    FirebaseOptions(
      apiKey: 'AIzaSyDmYBmY0ibtQ-5AsPKk-_QwS2IjBYfTW84',
      appId: '1:463199041980:web:b5bdda4c4f358e7919d3b9',
      storageBucket: "admission-preptime.appspot.com",
      messagingSenderId: '463199041980',
      databaseURL:
          "https://admission-preptime-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: 'admission-preptime',
    ),
  ];

  // * Flags
  bool fbInstanciated = false;
  bool dbInstanciated = false;

  FbProvider({required this.appInUse});

  // * Set Firestore and Realtime database instances
  Future<void> setDbs() async {
    if (!dbInstanciated) {
      store = FirebaseFirestore.instanceFor(app: appInUse);
      rtdb = FirebaseDatabase.instanceFor(app: appInUse);
      log('dbs instanciated');
      dbInstanciated = true;
    }
  }

  Future<void> setInstanceFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Classes? selectedClass =
        Classes.fromString(prefs.getString('selectedClass') ?? '');
    if (selectedClass != null) {
      await _setInstance(selectedClass)
          .catchError((error, stackTrace) => log(error.toString()));
    }
  }

  // * Initialize Firebase instances based on selected calss
  Future<void> _setInstance(Classes selectedClass) async {
    if (!fbInstanciated) {
      switch (selectedClass.key) {
        case 1:
          // ? keep default app for 1
          try {
            await setDbs()
                .catchError((error, stackTrace) => log(error.toString()));
          } catch (e) {
            log(e.toString());
          }
          break;
        case 2:
          try {
            for (final app in Firebase.apps) {
              if (app.name == 'cc') {
                appInUse = app;
                break;
              }
            }

            appInUse =
                await Firebase.initializeApp(name: 'cc', options: options[0]);
            await setDbs()
                .catchError((error, stackTrace) => log(error.toString()));
          } catch (e) {
            log(e.toString());
          }
          break;
        case 3:
          try {
            for (final app in Firebase.apps) {
              if (app.name == 'admission') {
                appInUse = app;
                break;
              }
            }
            appInUse = await Firebase.initializeApp(
                name: 'admission', options: options[1]);
            await setDbs()
                .catchError((error, stackTrace) => log(error.toString()));
          } catch (e) {
            log(e.toString());
          }
          break;
      }
      fbInstanciated = true;
      log('firebase instanciated');
    }
  }
}
