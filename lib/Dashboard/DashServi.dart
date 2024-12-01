import 'package:cloud_firestore/cloud_firestore.dart';

import 'DashModel.dart';

class FirebaseData {
  List data = [];
  static Future adddata(id, contactdetails) async {
    return await FirebaseFirestore.instance
        .collection('data')
        .doc(id)
        .set(contactdetails);
  }

  Stream<List<Data>> getdata() {
    return FirebaseFirestore.instance
        .collection('data')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Data.fromDocument(doc.data(), doc.id);
      }).toList();
    });
  }

  // Future updateContact(id, contactdetails) async {
  //   return await FirebaseFirestore.instance
  //       .collection('contact')
  //       .doc(id)
  //       .update(contactdetails);
  // }

  // static Future deleteContact(id) async {
  //   return await FirebaseFirestore.instance
  //       .collection('contact')
  //       .doc(id)
  //       .delete();
  // }
}
