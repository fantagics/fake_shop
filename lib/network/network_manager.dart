import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

import './network_error.dart';
import '../model/products.dart';
import '../service/products_service.dart';

class NetworkManager{
  final domain = 'https://fakestoreapi.com/';
  String reqUrl(String path){return domain+path;}

/// USER TOKEN
  Future<List<String>> getUserToken({
    required String userName,
    required String password
  }) async {
    String token = "";
    try{
      Response response = await Dio().post(
        reqUrl("auth/login"),
        data: {
          'username' : userName,
          'password' : password
        }
      );
      token = response.data['token'];
      return ["1", token];
    } on DioException catch (e){
      print(e.response?.statusCode);
      print(e.response?.data);
      var connectivityResult = await (Connectivity().checkConnectivity());
      String msg = NetworkErrors.getByCode(e.response?.statusCode, connectivityResult).description;
      return ["0", msg];
    }
  }
  
/// PRODUCT
  Future<void> getBestItemEachCategory({required BuildContext context}) async{
    ProductsService service = context.read<ProductsService>();
    try{
      Response resCate = await Dio().get(reqUrl("products/categories"));
      service.categories = List<String>.from(resCate.data);
    } on DioException catch (e){
      var connectivityResult = await (Connectivity().checkConnectivity());
      String msg = NetworkErrors.getByCode(e.response?.statusCode, connectivityResult).description;
      print(msg);//context.dialog(networkError)
    }
    try{
      for(String c in service.categories){
        Response resItems = await Dio().get(reqUrl("products/category/$c?limit=3"));
        List<Product> cateItem = List<Product>.from(resItems.data.map((p){return Product.fromJson(p);}).toList());
        service.recommend[c] = cateItem;
      }
    } on DioException catch (e){
      var connectivityResult = await (Connectivity().checkConnectivity());
      String msg = NetworkErrors.getByCode(e.response?.statusCode, connectivityResult).description;
      print(msg);//context.dialog(networkError)
    }
    service.changeLoadState(false);
  }

}
