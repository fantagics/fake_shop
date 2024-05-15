import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/products.dart';

class ProductsService extends ChangeNotifier{
  SharedPreferences prefs;
  ProductsService(this.prefs){}

  bool isLoading = false;
  final List<String> eventsImg = [
    'assets/event_0.png',
    'assets/event_1.png',
    'assets/event_2.png',
  ];
  List<String> categories = [];
  List<List<Product>> recommendedItems = [];
  Map<String,List<Product>> recommend = {};

  void changeLoadState(bool state){
    isLoading = state;
    notifyListeners();
  }

  // void updateCategories(List<String> newValue){
  //   categories = newValue;
  //   // notifyListeners(); //
  // }
  // void updateRecommends(List<List<Product>> newValue){
  //   recommendedItems = newValue;
  //   // notifyListeners();
  // }

}