import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/videomodel.dart';
import '../shared/widgets/elementcard.dart';


class VideosDatabase extends GetxController {
  late SharedPreferences _localDB;
  RxList history = <Widget>[].obs;
  @override
  void onInit() async {
    _localDB = await SharedPreferences.getInstance();
    getAllHistory();
    super.onInit();
  }

  void newHistoryRecord(Video video) async {
    Set<String> _localHistoryItems = _localDB.getKeys();
    if (!_localHistoryItems.contains(video.origin)) {
      _localDB.setString(
        video.origin,
        jsonEncode(
          {
            "thumbnail": video.thumbnailUrl,
            "title": video.title,
          },
        ),
      );
    }
    getAllHistory();
  }

  void getAllHistory() {
    Map<String, dynamic> _history = {};
    Set<String> _localHistoryItems = _localDB.getKeys();
    if (_localHistoryItems.isNotEmpty) {
      for (String item in _localHistoryItems) {
        Map<String, dynamic> jsonData =
        jsonDecode(_localDB.getString(item) ?? "{}");
        _history.putIfAbsent(item, () => jsonData);
      }
      history.clear();
      _history.forEach(
            (key, value) => history.add(
          ElementCard(
            origin: key,
            thumbnail: value["thumbnail"],
            title: value["title"],
          ),
        ),
      );
    }
  }

  // new
  void clearHistory() async {
    history.clear();
    await _localDB.clear();
    getAllHistory();
  }
}