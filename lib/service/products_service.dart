import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_manager.dart';

import '../model/products.dart';

class ProductsService extends ChangeNotifier{
  NetworkManager nm = NetworkManager();
  // SharedPreferences prefs;
  // ProductsService(this.prefs){}

  bool isLoading = false;
  final List<String> eventsImg = [
    'assets/event_0.png',
    'assets/event_1.png',
    'assets/event_2.png',
  ];
  List<String> categories = [];
  Map<String,List<Product>> recommend = {};
  String selectedCategory = 'all';
  List<Product> receivedProducts = [];
  List<Product> filteredProducts = [];
  List<Product> showProducts = [];
  final int addedCount = 8;
  // int productsPage = 0;
  String searchText = '';
  SortType sortType = SortType.recent;


  void changeLoadState(bool state){
    isLoading = state;
    notifyListeners();
  }

  void changeSelectedCategory(String newValue){
    selectedCategory = newValue;
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

  void getInitalProducts(String category) async{
    changeLoadState(true);
    selectedCategory = category;
    receivedProducts.clear();
    if(selectedCategory == 'all'){
      receivedProducts = await nm.getAllProducts();
    }else{
      receivedProducts = await nm.getProductsOf(category: selectedCategory);
    }
    // filteredProducts = receivedProducts;
    sortAndFilterProducts();
  }

  void sortAndFilterProducts(){
    filteredProducts.clear();
    showProducts.clear();
    switch(sortType){
      case SortType.recent:
        receivedProducts.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortType.highCost:
        receivedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.lowCost:
        receivedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.highRate:
        receivedProducts.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortType.highSales:
        receivedProducts.sort((a, b) => b.rating.count.compareTo(a.rating.count));
        break;
    }
    if(searchText.isNotEmpty){
      filteredProducts.addAll(receivedProducts.where((e){
        return e.title.contains(searchText);
      }).toList());
    } else{
      filteredProducts.addAll(receivedProducts);
    }
    addMoreProducts();
  }

  void addMoreProducts(){
    if(showProducts.length < filteredProducts.length){
      if(filteredProducts.length - showProducts.length < addedCount){
        showProducts.addAll(filteredProducts.sublist(showProducts.length, filteredProducts.length));
      } else {
        showProducts.addAll(filteredProducts.sublist(showProducts.length, showProducts.length + addedCount));
      }
    }
    isLoading = false;
    notifyListeners();
  }

}

enum SortType{
  recent(0,'recent'),
  highCost(1,'highCost'),
  lowCost(2,'lowCost'),
  highRate(3,'highRate'),
  highSales(4,'highSales');

  const SortType(this.idx, this.str);
  final int idx;
  final String str;
  
  factory SortType.getByIndex(int index){
    return SortType.values.firstWhere((element) => element.idx == index,
    orElse: () => SortType.recent);
  }
}