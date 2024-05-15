import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../color_asset/colors.dart';
import '../service/products_service.dart';
import '../model/translation_ko.dart';

drawerCategory({required BuildContext context}){
  ProductsService service = context.read<ProductsService>();
  return Drawer(
    backgroundColor: CsColors.cs.accentColor,
    child: Container(
      height: double.maxFinite,
      child: ListView.builder(
        itemCount: service.categories.length + 2,
        itemBuilder: (context, index) {
          if(index == 0){
            return Container(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 40),
              child: Center(
                child: Text('카테고리',
                  style: GoogleFonts.notoSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            );
          } else if(index == 1){
            return Card(
              color: CsColors.cs.accentColor,
              child: ListTile(
                title: Text("전체보기",
                  style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                ),
                onTap: (){},
              ),
            );
          } else{
            return Card(
              color: CsColors.cs.accentColor,
              child: ListTile(
                title: Text(CategoryKo[service.categories[index-2]] ?? service.categories[index-2],
                  style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                ),
                onTap: (){},
              ),
            );
          }
        },
      ),
    )
  );
}