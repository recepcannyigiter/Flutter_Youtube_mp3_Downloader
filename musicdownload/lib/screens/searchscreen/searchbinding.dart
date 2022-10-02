import 'package:get/get.dart';
import '../../controller/ytsearchcontroller.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(YoutubeSearchController());
  }
}