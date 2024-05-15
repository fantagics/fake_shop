import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.list),
                  SizedBox(width: 10,),
                  Text("주문내역")
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}


// import 'package:provider/provider.dart';
// import '../service/common_service.dart';
//
// Consumer<CommonService>(
//   builder: (context, value, child) {
//     return Center(
//       child: TextButton(
//         onPressed: (){
//           value.changeUserToken(null, LoginType.none);
//           Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
//         },
//         child: Text("로그아웃"),
//       ),
//     );
//   },
// )