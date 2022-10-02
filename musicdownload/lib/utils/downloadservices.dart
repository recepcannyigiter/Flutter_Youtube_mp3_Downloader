import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart' as getX;
import 'package:musicdownload/utils/videodatabase.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/videomodel.dart';
import '../shared/constant.dart';



class DownloadServices {
  static Future<Video?> getDownloadLinks(String videoID) async {
    List<Map<String, String>> _extractDownloadLinks(List<Element> domElements) {
      List<Map<String, String>> toBeReturned = [];
      for (Element i in domElements) {
        Map<String, String> _temp = {};
        _temp.putIfAbsent("url", () => "${i.attributes["href"]}");
        _temp.putIfAbsent(
            "type",
                () => i
                .getElementsByClassName("text-shadow-1")[0]
                .innerHtml
                .trim()
                .toUpperCase());
        _temp.putIfAbsent(
            "frequency",
                () => i
                .getElementsByClassName("text-shadow-1")[1]
                .innerHtml
                .trim()
                .toUpperCase());
        _temp.putIfAbsent("size",
                () => i.getElementsByClassName("text-shadow-1")[2].innerHtml);

        if (!toBeReturned.contains(_temp)) {
          toBeReturned.add(_temp);
        }
      }
      return toBeReturned;
    }

    try {
      print("İndirme başladı ... video ID = $videoID");
      Dio _client = Dio();
      Response mp3Response =
      await _client.get("https://api.vevioz.com/file/mp3/$videoID");
      Future.delayed(const Duration(seconds: 2));
      Response mp4Response =
      await _client.get("https://api.vevioz.com/file/mp4/$videoID");
      if (mp3Response.statusCode == 200 && mp4Response.statusCode == 200) {
        print("got status 200 now trying to prase HTML...");
        Document mp3Doc = parse(mp3Response.data);
        Document mp4Doc = parse(mp4Response.data);
        List<Element> thumbnailElements = mp3Doc.getElementsByTagName("img");
        List<Element> titleElements = mp3Doc.getElementsByClassName(
            "text-lg text-teal-600 font-bold m-2 text-center");

        List<Element> mp3downloadLinksElement = mp3Doc.getElementsByClassName(
            "shadow-xl bg-blue-600 text-white rounded-md p-2 border-solid border-2 border-black ml-2 mb-2 w-25");
        List<Element> mp4downloadLinksElement = mp4Doc.getElementsByClassName(
            "shadow-xl bg-blue-600 text-white rounded-md p-2 border-solid border-2 border-black ml-2 mb-2 w-25");
        List<Map<String, String>> mp3DownloadLinks =
        _extractDownloadLinks(mp3downloadLinksElement);
        List<Map<String, String>> mp4DownloadLinks =
        _extractDownloadLinks(mp4downloadLinksElement);
        String title = titleElements[0].innerHtml;
        String thumbnailUrl = thumbnailElements[0].attributes["src"].toString();

        Video record = Video(
          origin: videoID,
          title: title,
          mp3Urls: mp3DownloadLinks,
          mp4Urls: mp4DownloadLinks,
          thumbnailUrl: thumbnailUrl,
        );
        getX.Get.find<VideosDatabase>().newHistoryRecord(record);

        return record;
      } else {
        print("NULL döndüren 404 durumu var ...");
        return null;
      }
    } on DioError catch (e) {
      if (e.message.toLowerCase().contains("http status error")) {
        getX.Get.snackbar("Hata", "Geçersiz Youtube URL'si!",
            snackPosition: getX.SnackPosition.BOTTOM,
            colorText: kDarkBlueColor,
            backgroundGradient: const material.LinearGradient(colors: [
              material.Colors.red,
              material.Colors.orange,
              material.Colors.yellow
            ]));
      } else {
        getX.Get.snackbar("Hata", "hata : ${e.message}",
            snackPosition: getX.SnackPosition.BOTTOM,
            colorText: kDarkBlueColor,
            backgroundGradient: const material.LinearGradient(colors: [
              material.Colors.red,
              material.Colors.orange,
              material.Colors.yellow
            ]));
      }
    } catch (e) {
      print(e);
      getX.Get.snackbar(
          "Hata!", "Beklenmeyen hata! lütfen tekrar deneyin yönetici ile iletişime geçin!",
          snackPosition: getX.SnackPosition.BOTTOM);
      return null;
    }
    return null;
  }

  static Future<void> downloadFile(String url, String type) async {
    // request permissions
    bool isStorageAllowed = await Permission.storage.request().isGranted;
    _downloadForAndroid() async {
      try {
        String? selectedDirectory =
        await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory == null) {
        } else {
          await FlutterDownloader.enqueue(
            url: url,
            savedDir: selectedDirectory,
            requiresStorageNotLow: true,
            saveInPublicStorage: true,
            fileName: "dosya-${Random().nextInt(999999)}.${type.toLowerCase()}",
            showNotification: true,
            openFileFromNotification: false,
          );
        }
      } catch (e) {
        print(e);
        getX.Get.snackbar(
            "Hata!", "Beklenmeyen hata! lütfen tekrar deneyin yönetici ile iletişime geçin!",
            snackPosition: getX.SnackPosition.BOTTOM);
      }
    }

    if (isStorageAllowed) {
      _downloadForAndroid();
    }
  }
}