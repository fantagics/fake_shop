import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../color_asset/colors.dart';
import './login_field_subview.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController idTextFieldControl = TextEditingController();
  TextEditingController pwTextFieldControl = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Theme(
            data: loginFieldTheme,
            child: Column(
              children:[
                renderLoginField(
                  context: context,
                  label: "user name",
                  controller: idTextFieldControl,
                  secure: false,
                  next: true
                ),
                SizedBox(height: 16),
                renderLoginField(
                  context: context,
                  label: "password",
                  controller: pwTextFieldControl,
                  secure: true,
                  next: false
                ),
              ]
            ),
          ),
        ),
        SizedBox(height: 10,),
        termsAgreementBox(),
        SizedBox(height: 8),
        logInButton(context),
        SizedBox(height: 8),
        signInButton(context),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            kakaoLoginButton(context: context, isChecked: isChecked),
            SizedBox(width: 10),
            googleLoginButton(context: context, isChecked: isChecked),
            SizedBox(width: 10),
            appleLoginButton(context: context, isChecked: isChecked),
          ],
        ),
      ],
    );
  }

  Row termsAgreementBox() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked, 
            onChanged: (value){
              setState(() {
                isChecked = value!;
              });
            },
            activeColor: CsColors.cs.accentColor,
            checkColor: Colors.white,
            side: BorderSide(width: 1.4, color: CsColors.cs.accentColor),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity(
              horizontal: -2,
              vertical: -2,
            ),
          ),
          renderAgreementText(),
        ],
      );
  }

  ElevatedButton logInButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CsColors.cs.accentColor,
          minimumSize: Size(100, 45)
        ),
        onPressed: () async => loginProcess(
          context: context,
          isChecked: isChecked,
          idControl: idTextFieldControl,
          pwControl: pwTextFieldControl,
        ),
        child: Text("로그인",
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      );
  }

  TextButton signInButton(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.all(4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap
        ),
        onPressed: (){
          Navigator.pushNamed(context, '/signup');
        },
        child: Text("회원가입",
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CsColors.cs.accentColor
          ),
        ),
      );
  }
}
