import 'package:get/get.dart';

import 'app.dart';

class SettingsController extends GetxController {
  late final RxString firstName;
  late final RxString lastName;
  final RxBool status = false.obs;

  SettingsController() {
    final AppController controller = Get.find<AppController>();

    firstName = controller.user!.firstName.obs;
    lastName = controller.user!.lastName.obs;
  }
}
