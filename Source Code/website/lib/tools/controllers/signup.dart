import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;

  final Map<String, RxString> errors = {
    "firstName": "".obs,
    "lastName": "".obs,
    "email": "".obs,
    "password": "".obs,
  };

  Map<String, dynamic> get toJson => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      };
}
