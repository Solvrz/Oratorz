import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/models/committee.dart';
import '/services/local_storage.dart';
import '../functions.dart';

class SetupController extends GetxController {
  SetupController({required Committee committee, required this.editing}) {
    _committee = committee.obs;
  }

  late final Rx<Committee> _committee;
  late bool editing = false;
  final RxInt _selectedType = 0.obs;
  final RxBool status = false.obs;
  final RxBool showOptions = false.obs;

  Committee get committee => _committee.value;

  int get selectedType => _selectedType.value;
  set selectedType(int newCommitteeType) =>
      _selectedType.value = newCommitteeType;

  void fromTemplate(String template) => _committee.update((committee) {
        if (committee != null) {
          committee.name = template;
          committee.type = template;
          committee.delegates = COMMITTEES[template]!.toList();

          sort();
        }
      });

  void add(String delegate) => _committee.update((committee) {
        committee?.delegates.add(delegate);
        sort();
      });

  void remove(String delegate) => _committee.update((committee) {
        committee?.delegates.remove(delegate);
        sort();
      });

  void removeAt(int index) => _committee.update((committee) {
        committee?.delegates.removeAt(index);
        sort();
      });

  void clearDelegatePage() {
    _committee.update((committee) {
      committee?.delegates.clear();
      committee?.name = "Your Committee";
    });

    LocalStorage.saveSetup();
  }

  void clearOptionsPage() {
    _committee.update((committee) {
      committee?.members = [FirebaseAuth.instance.currentUser!.email!];
      committee?.days = [];
    });

    LocalStorage.saveSetup();
  }

  void sort() => committee.delegates
      .sort((a, b) => DELEGATES[a]!.compareTo(DELEGATES[b]!));

  bool validate(BuildContext context) {
    String message = "";

    //FIXME: EMAIL REGEX
    if (committee.members.any(
      (member) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(member),
    )) {
      message = "Please provide valid emails for members";
    }

    if (committee.days.any((day) => day == null)) {
      message = "Please select dates for all the committee days";
    }

    if (committee.days.isEmpty) {
      message = "Please select atleast one committee day";
    }

    if (message != "") {
      snackbar(context, Center(child: Text(message)));
      return false;
    } else {
      return true;
    }
  }
}
