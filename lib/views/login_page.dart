import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../service/common_service.dart';
import './sub/login_field.dart';
import './sub/circle_progress_indicator_widget.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonService>(
      builder: (context, value, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              SafeArea(
                child: GestureDetector(
                  onTap: (){ FocusScope.of(context).unfocus(); },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: (MediaQuery.of(context).size.height / 2) - 157 - MediaQuery.of(context).padding.top,
                            child: Center(
                              child:  SizedBox(
                                width: double.infinity,
                                child: welcomeTitle(),
                              )
                            ),
                          ),
                          SizedBox(height: 6),
                          LoginForm(),
                          SizedBox(height: (MediaQuery.of(context).size.height / 2) - 250 - MediaQuery.of(context).padding.bottom)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              value.isLoading ? CircleProgerssIndicator() : Container()
            ]
          )
        );
      }
    );
  }
}

welcomeTitle(){
  return  RichText(
    textAlign: TextAlign.start,
    text: TextSpan(
      style: GoogleFonts.notoSans(
        color: Colors.black,
        fontSize: 16,
      ),
      children: [
        TextSpan(text: "환영합니다 !\n",
          style: GoogleFonts.notoSans(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            
          ),
        ),
        TextSpan(text: "\'"),
        TextSpan(text: "페이크샵",
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold
          )
        ),
        TextSpan(text: "\'은 \'"),
        TextSpan(text: "fakestoreapi",
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold
          )
        ),
        TextSpan(text: "\'을 사용한 가짜 쇼핑 앱입니다. "),
        TextSpan(text: "(개발 이태형)(mor_2314/83r5^_)",
          style: GoogleFonts.notoSans(
            color: Colors.grey
          )
        ),
      ]
    ),
  );
}