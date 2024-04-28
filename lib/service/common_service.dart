import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonService extends ChangeNotifier{
  SharedPreferences prefs;
  CommonService(this.prefs){
    if(prefs.getString("userToken") != null){
      userToken = prefs.getString("userToken")!;
    }
  }

  String? userToken;
  bool isLoading = false;

  void changeUserToken(String? token){
    if(token == null){
      prefs.remove("userToken");
    } else{ prefs.setString("userToken", token); }
    userToken = token;
    notifyListeners();
  }

  void changeLoadState(bool state){
    isLoading = state;
    notifyListeners();
  }
}