import 'package:firebase_core/firebase_core.dart';

class FbInstances {
  // * Static Firebase product instances
  // *

  // * Initialize default firebase app
  static initializeDefault() {
    Firebase.initializeApp();
  }

  // * Set Firestore & RTDB instances
  // * From secondary firebase app
  static setInstances(/* Take app ids and keys */) {}
}
