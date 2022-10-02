import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/searchresultsmodel.dart';
import '../utils/searchservice.dart';



class YoutubeSearchController extends GetxController {
  final TextEditingController _youtubeSearchInputController =
  TextEditingController();
  String searchTerm = "";
  final RxList searchResults = <SearchResult>[].obs;
  final RxInt currentPage = 1.obs;
  final RxString nextPageToken = "".obs;
  final RxString prevPageToken = "".obs;
  final RxInt resultsCount = 0.obs;
  final RxBool isLoading = false.obs;

  void searchItem([String pageToken = ""]) async {
    String searhQuery = _youtubeSearchInputController.text;
    if (searhQuery.isNotEmpty) {
      if (searchResults.isNotEmpty) {
        searchResults.clear();
        nextPageToken.value = "";
        resultsCount.value = 0;
        isLoading.value = false;
        currentPage.value = (pageToken != "") ? currentPage.value : 1;
      }
      isLoading.value = true;
      Map<String, dynamic> search_results =
      await SearchServices.search(searhQuery, pageToken);
      searchResults.addAll(search_results["resultsList"]);
      resultsCount.value = search_results["resulstsCount"];
      nextPageToken.value = search_results["nextPageToken"];
      prevPageToken.value = search_results["nextPageToken"];
      isLoading.value = false;
    } else {
      Get.snackbar(
        "Hata!",
        "Lütfen bir arama sorgusu girin!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundGradient: const LinearGradient(
          colors: [Colors.red, Colors.orange, Colors.yellow],
        ),
      );
    }
  }

  void goToNext() {
    if (currentPage.value != (resultsCount / 10)) {
      currentPage.value += 1;
      searchItem(nextPageToken.value);
    }
  }

  void goToPrev() {
    if (currentPage.value == 1 || currentPage.value < 1) {
      currentPage.value = 1;
      searchItem();
    } else {
      currentPage.value -= 1;
      searchItem(prevPageToken.value);
    }
  }

  TextEditingController get youtubeInputSearchController =>
      _youtubeSearchInputController;

  @override
  void onReady() {
    if (_youtubeSearchInputController.text.isNotEmpty) {
      searchItem();
    }
    super.onReady();
  }
}