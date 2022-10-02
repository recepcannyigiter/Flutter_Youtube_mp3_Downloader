import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;

import '../env_config/youtubeconfigs.dart';
import '../models/searchresultsmodel.dart';


class SearchServices {

  static Future<Map<String, dynamic>> search(String query,
      [String nextPageToken = ""]) async {
    try {
      Dio _client = Dio();
      // await Future.delayed(Duration(seconds: 2));
      Response response =
      await _client.get(YoutubeConfig.API_ENDPOINT, queryParameters: {
        "q": query,
        "key": YoutubeConfig.API_KEY,
        "type": "video",
        "maxResults": "${YoutubeConfig.SEARCH_MAXRESULTS}",
        "part": "snippet",
        "pageToken": nextPageToken,
      });
      if (response.statusCode == 200) {
        int resulstsCount = response.data["pageInfo"]["totalResults"];
        String nextPageToken = response.data["nextPageToken"];
        String prevPageToken = response.data["prevPageToken"] ?? "";
        List<SearchResult> _resultsList = [];
        for (Map<String, dynamic> result in response.data["items"]) {
          _resultsList.add(SearchResult.fromMap(result));
        }
        return {
          "resulstsCount": resulstsCount,
          "resultsList": _resultsList,
          "nextPageToken": nextPageToken,
          "prevPageToken": prevPageToken,
        };
      } else {
        getX.Get.snackbar(
          "Error",
          "error code : ${response.statusCode}",
          snackPosition: getX.SnackPosition.BOTTOM,
          backgroundGradient: const LinearGradient(
            colors: [Colors.red, Colors.orange, Colors.yellow],
          ),
        );
        return {
          "resulstsCount": 0,
          "resultsList": [],
          "nextPageToken": "",
        };
      }
    } catch (e) {
      print(e);
      getX.Get.snackbar(
        "Error",
        "error : $e",
        snackPosition: getX.SnackPosition.BOTTOM,
        backgroundGradient: const LinearGradient(
          colors: [Colors.red, Colors.orange, Colors.yellow],
        ),
      );
      return {
        "resulstsCount": 0,
        "resultsList": [],
        "nextPageToken": "",
      };
    }
  }
}