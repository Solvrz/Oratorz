import 'package:get/get.dart';

class SignInController extends GetxController {
  RxString email = "".obs;
  RxString password = "".obs;
  RxBool status = false.obs;

  final Map<String, RxString> errors = {
    "email": "".obs,
    "password": "".obs,
  };

  Map<String, dynamic> get toJson => {
        "email": email,
        "password": password,
      };
}
