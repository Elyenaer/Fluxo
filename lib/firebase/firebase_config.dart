
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig{

  static start() async {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBWHADRy995r4uBl-eeoLoOrb27J5Gb0fA",
        authDomain: "fir-demo-65ace.firebaseapp.com",
        projectId: "fir-demo-65ace",
        storageBucket: "fir-demo-65ace.appspot.com",
        messagingSenderId: "157354318879",
        appId: "1:157354318879:web:606556d582a1aaf32d492a",
        measurementId: "G-CT86Q2K740"
      )
    );
  }


}