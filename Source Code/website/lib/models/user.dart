import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../services/uid.dart';
import '../tools/controllers/app.dart';
import 'committee.dart';

class User {
  late final String id;
  final String firstName;
  final String lastName;
  final String email;
  late final Timestamp createdAt;
  late final List<Committee> committees;

  User({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.email,
    Timestamp? createdAt,
    List<Committee>? committees,
  }) {
    this.id = id ?? Uid.generate();
    this.createdAt = createdAt ?? Timestamp.now();
    this.committees = committees ?? [];
  }

  factory User.fromJson(Map<String, dynamic> data) {
    final User user = User(
      id: data["id"],
      email: data["email"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      createdAt:
          Timestamp.fromMillisecondsSinceEpoch(int.parse(data["createdAt"])),
    );

    for (final String id in data["committees"]) {
      FirebaseFirestore.instance
          .collection("committees")
          .doc(id)
          .get()
          .then((doc) {
        user.committees.add(Committee.fromJson(doc.data()!));
        Get.find<AppController>().update();
      });
    }

    return user;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": createdAt.millisecondsSinceEpoch.toString(),
        "committees": committees.map<String>((e) => e.id),
      };
}
