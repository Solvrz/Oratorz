import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RouteController extends GetxController {
  late RxString path;
  late Rx<Object?> args;

  RouteController({required GoRouterState arguments}) {
    path = arguments.location.obs;
    args = arguments.extra.obs;
  }
}
