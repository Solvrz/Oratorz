import 'package:get/get.dart';

import '/models/committee.dart';

class CommitteeController extends GetxController {
  late Rx<Committee> committee;

  CommitteeController({required Committee committee}) {
    this.committee = committee.obs;
  }
}
