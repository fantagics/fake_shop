import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../color_asset/colors.dart';
import '../service/products_service.dart';
import '../model/translation_ko.dart';

drawerCategory({required BuildContext context}){
  ProductsService service = context.read<ProductsService>();
  
  return Drawer(
    backgroundColor: CsColors.cs.accentColor,
    child: SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8, right: 18
        ),
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
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  title: Text("전체보기",
                    style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CsColors.cs.darkAccentColor
                      ),
                  ),
                  onTap: (){
                    service.searchText = '';
                    service.sortType = SortType.recent;
                    service.getInitalProducts(category: 'all');
                    Navigator.pushNamed(context, '/productsList');
                  },
                ),
              );
            } else{
              return Card(
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  title: Text(CategoryKo[service.categories[index-2]] ?? service.categories[index-2],
                    style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CsColors.cs.darkAccentColor
                      ),
                  ),
                  onTap: (){
                    service.searchText = '';
                    service.sortType = SortType.recent;
                    service.getInitalProducts(category: service.categories[index-2]);
                    Navigator.pushNamed(context, '/productsList');
                  },
                ),
              );
            }
          },
        ),
      ),
    )
  );
}