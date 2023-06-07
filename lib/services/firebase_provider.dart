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
      apiKey: 'AIzaSyCH38zdmHoOLGop12VC2H4cg3Zj1MZBBZw',
      appId: 'c46ca5556a8ca2c4728b8d',
      messagingSenderId: '609123727992',
      projectId: 'preptime',
      authDomain: "preptime-bd.firebaseapp.com",
    ),
    FirebaseOptions(
      apiKey: 'AIzaSyCH38zdmHoOLGop12VC2H4cg3Zj1MZBBZw',
      appId: 'c46ca5556a8ca2c4728b8d',
      messagingSenderId: '609123727992',
      projectId: 'preptime',
      authDomain: "preptime-bd.firebaseapp.com",
    )
  ];

  FbProvider({required this.appInUse}) {
    setInstanceFromStorage();
  }

  // * Set Firestore and Realtime database instances
  setDbs() {
    store = FirebaseFirestore.instanceFor(app: appInUse);
    rtdb = FirebaseDatabase.instanceFor(app: appInUse);
  }

  setInstanceFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Classes? selectedClass =
        Classes.fromString(prefs.getString('selectedClass') ?? '');
    if (selectedClass != null) {
      setInstance(selectedClass);
    }
    setDbs();
  }

  // * Initialize Firebase instances based on selected calss
  setInstance(Classes selectedClass) async {
    // TODO implement selected firebase
    switch (selectedClass.key) {
      case 1:
        // ? keep default app for 1
        break;
      case 2:
        appInUse = await Firebase.initializeApp(options: options[0]);
        setDbs();
        break;
      case 3:
        appInUse = await Firebase.initializeApp(options: options[1]);
        setDbs();
        break;
    }
  }
}
