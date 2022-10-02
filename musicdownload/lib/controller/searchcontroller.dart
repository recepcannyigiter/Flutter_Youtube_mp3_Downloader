import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/videomodel.dart';
import '../utils/downloadservices.dart';

class SearchController extends GetxController {
  final TextEditingController _searchInputController = TextEditingController();
  Video? video;
  bool isSheetOpen = false;
  bool isLoading = true;
  RxDouble downloadPercentage = 0.0.obs;
  get searchInputController => _searchInputController;
  // validate input
  void validate([String url = ""]) async {
    String searchInputText = _searchInputController.text.toLowerCase();
    if (url != "") {
      searchInputText = url;
    }
    if (searchInputText.isNotEmpty) {
      if (searchInputText.contains("https://") ||
          searchInputText.contains("http://")) {
        if (searchInputText.contains("youtube.com")) {
          String videoID = (url != "")
              ? url.split("youtube.com/watch?v=").last
              : _searchInputController.text.split("youtube.com/watch?v=").last;
          isSheetOpen = true;
          update();
          await Future.delayed(const Duration(seconds: 2));
          video = await DownloadServices.getDownloadLinks(videoID);
          isLoading = false;
          _searchInputController.clear();
          update();
        } else if (searchInputText.contains("youtu.be")) {
          String videoID = (url != "")
              ? url.split("youtu.be").last
              : _searchInputController.text.split("youtu.be").last;
          isSheetOpen = true;
          update();
          await Future.delayed(const Duration(seconds: 2));
          video = await DownloadServices.getDownloadLinks(videoID);
          isLoading = false;
          _searchInputController.clear();
          update();
        } else {
          Get.snackbar("Hata!", "şu anda yalnızca youtube indirmelerini destekliyoruz!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundGradient: const LinearGradient(
                  colors: [Colors.red, Colors.orange, Colors.yellow]));
        }
      } else {
        Get.toNamed("/search", arguments: {
          "searchValue": searchInputText,
        });
      }
    } else {
      Get.snackbar("Hata!", "Giriş boş olamaz!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange, Colors.pinkAccent]));
    }
  }

  void closeSheet() {
    isSheetOpen = false;
    isLoading = true;
    video = null;
    _searchInputController.clear();
    update();
  }
}