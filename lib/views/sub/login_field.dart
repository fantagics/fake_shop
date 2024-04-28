import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../service/common_service.dart';
import '../../color_asset/colors.dart';
import './login_field_subview.dart';
import '../../network/network_manager.dart';
import './app_dialoges.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController idTextFieldControl = TextEditingController();
  TextEditingController pwTextFieldControl = TextEditingController();
  bool isChecked = false;
  // final nm = NetworkManager();

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
        Row(
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
        ),
        SizedBox(height: 8),
        ElevatedButton(
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
        ),
        SizedBox(height: 8),
        TextButton(
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
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circleShadow(
              child: GestureDetector(
                onTap: (){
                  print("K");
                }, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/Kakao_logo.png',
                    width: 36, height: 36,
                    fit: BoxFit.cover,
                  ),
                )
              )
            ),
            SizedBox(width: 10),
            circleShadow(
              child: GestureDetector(
                onTap: (){
                  print("G");
                }, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/google_logo.png',
                    width: 36, height: 36,
                    fit: BoxFit.cover,
                  ),
                )
              )
            ),
            SizedBox(width: 10),
            circleShadow(
              child: GestureDetector(
                onTap: (){
                  print("A");
                }, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset('assets/apple_logo.png',
                    width: 36, height: 36,
                    fit: BoxFit.cover,
                  ),
                )
              )
            ),
          ],
        ),
      ],
    );
  }
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
  CommonService service = context.read<CommonService>();
  service.changeLoadState(true);
  final res = await nm.getUserToken(userName: 'mor_2314', password: '83r5^_');
  // final res = await nm.getUserToken(
  //   userName: idControl.text, 
  //   password: pwControl.text
  // );
  print(res);
  service.changeLoadState(false);
  if(res[0] == "1"){
    service.changeUserToken(res[1]);
  } else {
    justConfirmDialog(context: context,
      description: res[1]
    );
  }
}