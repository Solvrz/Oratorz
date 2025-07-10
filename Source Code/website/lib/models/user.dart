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
  late final List<String> _committeesId;

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
      createdAt: Timestamp.fromMillisecondsSinceEpoch(
        int.parse(data["createdAt"]),
      ),
    );

    user._committeesId = data["committees"].cast<String>();

    return user;
  }

  bool _isCommitteeLoaded(String id) {
    return committees.any((elem) => elem.id == id);
  }

  Future<List<Committee>> fetchCommittees() async {
    await Future.wait(
      _committeesId.map<Future<Committee>>((id) => fetchCommittee(id)),
    );

    return committees;
  }

  Future<Committee> fetchCommittee(String? id) async {
    if (id == null) {
      return Committee();
    }

    if (_isCommitteeLoaded(id)) {
      return committees.firstWhere((elem) => elem.id == id);
    } else {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("committees")
          .doc(id)
          .get();

      final Committee committee = Committee.fromJson(doc.data()!);

      committees.add(committee);
      Get.find<AppController>().update();

      return committee;
    }
  }

  void addCommittee(Committee committee) {
    committees.add(committee);
    _committeesId.add(committee.id);
  }

  void deleteCommittee(Committee committee) {
    committees.remove(committee);
    _committeesId.remove(committee.id);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": createdAt.millisecondsSinceEpoch.toString(),
        "committees": _committeesId,
      };
}
