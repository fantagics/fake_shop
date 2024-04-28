import 'dart:async';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import './network_error.dart';

class NetworkManager{
  final domain = 'https://fakestoreapi.com/';
  String reqUrl(String path){return domain+path;}

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
}
