import 'package:flutter/material.dart';
import 'package:flutter_music_app/provider/view_state_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kSearchHistory = 'kSearchHistory';

class SearchHistoryModel extends ViewStateListModel<String> {
  clearHistory() async {
    debugPrint('clearHistory');
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(kSearchHistory);
    list.clear();
    setEmpty();
  }

  addHistory(String keyword) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var histories = sharedPreferences.getStringList(kSearchHistory) ?? [];
    histories
      ..remove(keyword)
      ..insert(0, keyword);
    await sharedPreferences.setStringList(kSearchHistory, histories);
    notifyListeners();
  }

  @override
  Future<List<String>> loadData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(kSearchHistory) ?? [];
  }
}