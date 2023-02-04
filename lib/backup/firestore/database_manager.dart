import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("financial_entry");

  Future getData() async {
    try {

      //to get data from a single/particular document alone.
      /*var temp = await collectionRef.doc("3").get().then(
        (DocumentSnapshot doc) {
          return doc.data() as Map<String, dynamic>;
        },
        onError: (e) => debugPrint("Error getting document: $e"),
      );*/



      // to get data from all documents sequentially
      /*await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          studentsList.add(result.data());
        }
      });*/

    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> setData(data) async {
    await printDocID();
    final city = <String, String>{
      'id': "3",
      'description': "mais um teste outra vez",
      'value': "4500"
    };

    collectionRef.doc("3").set(city).catchError((error)
     => debugPrint("Failed to add user: $error"));
  }

  Future<void> addField() {
    return collectionRef
        .doc('MyDoc')
        //will edit the doc if already available or will create a new doc with this given ID
        .set(
          {'role': "developer"},
          SetOptions(merge: true),
          // if set to 'false', then only these given fields will be added to that doc
        )
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  printDocID() async {
    var querySnapshots = await collectionRef.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      debugPrint(documentID);
    }
  }
}
