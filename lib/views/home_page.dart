import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import '../service/common_service.dart';
import '../color_asset/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: CsColors.cs.accentColor,
      ),
      body: Consumer<CommonService>(
        builder: (context, value, child) {
          return Center(
            child: TextButton(
              onPressed: (){
                value.changeUserToken(null);
              },
              child: Text("로그아웃"),
            ),
          );
        },
      )
    );
  }
}