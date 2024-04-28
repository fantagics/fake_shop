import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../color_asset/colors.dart';

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