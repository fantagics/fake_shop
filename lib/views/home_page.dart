import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../color_asset/colors.dart';
import './drawer_page.dart';
import './main_page.dart';
import './user_info_page.dart';
import '../network/network_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int tabIndex = 1;
  NetworkManager nm = NetworkManager();

  @override
  Widget build(BuildContext context) {
    nm.getBestItemEachCategory(context: context);
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        title: Image.asset('assets/appBarLogo.png',
          height: MediaQuery.of(context).padding.top - 18,
        ),
        centerTitle: true,
        backgroundColor: CsColors.cs.accentColor,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.cart, color: Colors.white,),
            onPressed: (){}
          ),
          SizedBox(width: 8),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: tabIndex - 1,
          children: [
            HomeMainPage(),
            UserInfoPage()
          ],
        ),
      ),
      drawer: drawerCategory(context: context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (newValue){
          setState(() {
            if(newValue == 0){
              _drawerKey.currentState?.openDrawer();
            } else {
              tabIndex = newValue;
            }
          });
        },
        backgroundColor: CsColors.cs.accentColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: ""),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_fill), label: ""),
        ],
      ),
    );
  }
}
