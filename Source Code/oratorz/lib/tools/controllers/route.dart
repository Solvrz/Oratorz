import 'package:advanced_navigator/advanced_navigator.dart';
import 'package:get/get.dart';

class RouteController extends GetxController {
  late RxMap<String, dynamic> path;
  late Rx<Object?> args;

  RouteController({required PathArguments arguments}) {
    path = arguments.path.obs;
    args = arguments.arguments.obs;
  }
}
