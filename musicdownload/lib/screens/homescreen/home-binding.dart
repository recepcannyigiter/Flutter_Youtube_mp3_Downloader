import 'package:get/get.dart';

import '../../controller/adscontrol.dart';
import '../../controller/searchcontroller.dart';
import '../../utils/videodatabase.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchController());
    Get.put(VideosDatabase(), permanent: true);
    Get.lazyPut(() => AdsController(), fenix: true);
  }
}