import 'package:get/get.dart';

import '../controllers/cari_controller.dart';

class CariBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CariController>(
      () => CariController(),
    );
  }
}
