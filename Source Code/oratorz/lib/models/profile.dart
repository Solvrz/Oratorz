import 'package:cloud_firestore/cloud_firestore.dart';

import '/services/firebase.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final num contactNo;
  final DocumentReference reference;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.reference,
  });

  static Future<Profile> fromID(String id) async {
    final DocumentSnapshot doc =
        await CloudFirestore.get("users/$id") as DocumentSnapshot;

    return Profile(
      id: id,
      name: doc.get("name") as String,
      email: doc.get("email") as String,
      contactNo: doc.get("contactNo") as num,
      reference: doc.reference,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "contactNo": contactNo,
      };
}
