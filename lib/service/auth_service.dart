import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthService extends ChangeNotifier{
  SharedPreferences prefs;
  AuthService(this.prefs){
    if(prefs.getString("userToken") != null){
      userToken = prefs.getString("userToken")!;
      loginType = LoginType.getByString(prefs.getString("loginType") ?? 'none');
    }
  }

  String? userToken;
  LoginType loginType = LoginType.none;
  bool isLoading = false;

  void changeUserToken(String? token, LoginType type) async{
    if(token == null){ //logout
      prefs.remove("userToken");
      switch(loginType){
        case LoginType.kakao:
          try {
            await UserApi.instance.logout();
            print('로그아웃 성공, SDK에서 토큰 삭제');
          } catch (error) {
            print('로그아웃 실패, SDK에서 토큰 삭제 $error');
          }
          break;
        // case LoginType.none: //잘못된 상황(어떤 타입인지 모름)
        default:
          break;
      }
    } else{ //login
      prefs.setString("userToken", token);
    }
    userToken = token;
    loginType = type;
    notifyListeners();
  }

  void changeLoadState(bool state){
    isLoading = state;
    notifyListeners();
  }
}

enum LoginType{
  kakao('kakao'), 
  google('google'), 
  apple('apple'), 
  email('email'), 
  none('none');

  const LoginType(this.str);
  final String str;

  factory LoginType.getByString(String str){
    return LoginType.values.firstWhere((value) => value.str == str,
    orElse: () => LoginType.none);
  }
}