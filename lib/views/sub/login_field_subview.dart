import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../color_asset/colors.dart';
import '../../service/auth_service.dart';
import '../../network/network_manager.dart';
import './app_dialoges.dart';

ThemeData loginFieldTheme = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: CsColors.cs.accentColor,
      fontSize: 16,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(width: 2, color: CsColors.cs.accentColor)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(width: 2, color: CsColors.cs.accentColor)
    ),
    suffixIconColor: CsColors.cs.accentColor,
    isDense: true,
    contentPadding: EdgeInsets.fromLTRB(21, 20, 20, 12),
  )
);

renderLoginField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required bool secure,
  required bool next
}){
  return TextField(
    controller: controller,
    keyboardType: TextInputType.text,
    style: GoogleFonts.notoSans(
      fontSize: 16
    ),
    cursorColor: CsColors.cs.accentColor,
    obscureText: secure,
    decoration: InputDecoration(
      labelText: label,
      suffixIcon: IconButton(
        icon: Icon(Icons.clear, size: 20,),
        onPressed: controller.clear,
      )
    ),
    textInputAction: next ? TextInputAction.next : TextInputAction.done,
    onSubmitted: (_){
      if(next){
        FocusScope.of(context).nextFocus();
      } else{
        FocusScope.of(context).unfocus();
      }
    },
  );
}

renderAgreementText(){
  return RichText(
    text: TextSpan(
      style: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 14
      ),
      children: [
        TextSpan(text: "이용약관",
          style: GoogleFonts.notoSans(
            color: CsColors.cs.accentColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline
          ),
          recognizer: TapGestureRecognizer()..onTap = () async{
            await launchUrl(Uri.parse("https://www.google.co.kr/"));
          }
        ),
        TextSpan(text: "과 "),
        TextSpan(text: "개인정보약관",
          style: GoogleFonts.notoSans(
            color: CsColors.cs.accentColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline
          ),
          recognizer: TapGestureRecognizer()..onTap = () async{
            await launchUrl(Uri.parse("https://www.google.co.kr/"));
          }
        ),
        TextSpan(text: "에 동의합니다."),
      ]
    )
  );
}

circleShadow({
  required Widget child
}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(1, 2),
        )
      ]
    ),
    child: child
  );
}

kakaoLoginButton({
  required BuildContext context,
  required bool isChecked
}){
  AuthService service = context.read<AuthService>();
  return circleShadow(
    child: GestureDetector(
      onTap: () async{
        if(!isChecked){
          justConfirmDialog(context: context,
            description: "이용약관 및 개인정보약관 동의에 체크해주세요.",
          );
          return;
        }
        if (await isKakaoTalkInstalled()) { //login for logined app
          try {
              OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
              service.changeUserToken(token.accessToken, LoginType.kakao);
              print('카카오톡으로 로그인 성공');
              Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
          } catch (error) {
              print('카카오톡으로 로그인 실패 $error');
              if (error is PlatformException && error.code == 'CANCELED') {
                  return; // 의도적인 로그인 취소
              }
            // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
            try {
                OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
                service.changeUserToken(token.accessToken, LoginType.kakao);
                print('카카오계정으로 로그인 성공');
                Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
            } catch (error) {
                print('카카오계정으로 로그인 실패 $error');
            }
          }
        } else { //login for account
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            service.changeUserToken(token.accessToken, LoginType.kakao);
            print('카카오계정으로 로그인 성공');
            Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      }, 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset('assets/Kakao_logo.png',
          width: 36, height: 36,
          fit: BoxFit.cover,
        ),
      )
    )
  );
}

googleLoginButton({
  required BuildContext context,
  required bool isChecked
}){
  AuthService service = context.read<AuthService>();
  return circleShadow(
    child: GestureDetector(
      onTap: () async{
        if(!isChecked){
          justConfirmDialog(context: context,
            description: "이용약관 및 개인정보약관 동의에 체크해주세요.",
          );
          return;
        }
        print("google login sdk");
      }, 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset('assets/google_logo.png',
          width: 36, height: 36,
          fit: BoxFit.cover,
        ),
      )
    )
  );
}

appleLoginButton({
  required BuildContext context,
  required bool isChecked
}){
  AuthService service = context.read<AuthService>();
  return circleShadow(
    child: GestureDetector(
      onTap: () async{
        if(!isChecked){
          justConfirmDialog(context: context,
            description: "이용약관 및 개인정보약관 동의에 체크해주세요.",
          );
          return;
        }
        print("apple login sdk");
      }, 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset('assets/apple_logo.png',
          width: 36, height: 36,
          fit: BoxFit.cover,
        ),
      )
    )
  );
}

void loginProcess({
  required BuildContext context,
  required bool isChecked,
  required TextEditingController idControl,
  required TextEditingController pwControl,
}) async{
  final nm = NetworkManager();
  if(idControl.text.isEmpty || pwControl.text.isEmpty){
    justConfirmDialog(context: context,
      description: "user name 및 password를 입력해주세요.",
    );
    return;
  }
  if(!isChecked){
    justConfirmDialog(context: context,
      description: "이용약관 및 개인정보약관 동의에 체크해주세요.",
    );
    return;
  }
  AuthService service = context.read<AuthService>();
  service.changeLoadState(true);
  // final res = await nm.getUserToken(userName: 'mor_2314', password: '83r5^_');
  final res = await nm.getUserToken(
    userName: idControl.text, 
    password: pwControl.text
  );
  print(res);
  service.changeLoadState(false);
  if(res[0] == "1"){
    service.changeUserToken(res[1], LoginType.email);
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  } else {
    justConfirmDialog(context: context,
      description: res[1]
    );
  }
}