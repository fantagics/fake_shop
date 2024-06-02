import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../color_asset/colors.dart';
import '../model/translation_ko.dart';
import './sub/category_picker_bottom_sheet.dart';
import '../service/products_service.dart';
import './sub/circle_progress_indicator_widget.dart';
import '../model/products.dart';
import '../model/arguments/product_info_arguments.dart';
import '../network/network_manager.dart';
import './sub/sort_type_picker_bottom_sheet.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late ScrollController _controller;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController()..addListener(nextLoad);
  }

  @override
  Widget build(BuildContext context) {
    const double cellAxisSpace = 16;
    final double cellWidth = (MediaQuery.of(context).size.width - (cellAxisSpace * 3)) / 2;
    final double cellHeight = cellWidth + 85;

    return Consumer<ProductsService>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CsColors.cs.accentColor,
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            title: GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, 
                  builder: (context) {
                    return CategoryPickerBottomSheet(controller: _controller);
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.4,
                    color: Colors.white
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                  child: Text("${CategoryKo[value.selectedCategory] ?? value.selectedCategory} ▾",
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    )
                  ),
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.cart, color: Colors.white,),
                onPressed: (){
                }
              ),
              SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 56),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(child: TextField(
                      controller: _textController,
                      onSubmitted: (v){},
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        filled: true, fillColor: Colors.white,
                        hintText: "제품명을 검색하세요.",
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 8),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: _textController.clear,
                        ),
                      ),
                      cursorColor: CsColors.cs.accentColor,
                    )),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: (){
                        value.changeLoadState(true);
                        value.searchText = _textController.text;
                        value.sortAndFilterProducts();
                        _controller.jumpTo(0);
                      },
                      child: circleAppBarButton(
                        child: Icon(Icons.search, color: CsColors.cs.accentColor,)
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: (){
                        showModalBottomSheet(context: context, 
                          builder: (context) {
                            return SortTypePickerBottomSheet(controller: _controller,);
                          },
                        );
                      },
                      child: circleAppBarButton(
                        child: Icon(CupertinoIcons.line_horizontal_3_decrease, color: CsColors.cs.accentColor,)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(cellAxisSpace),
                // height: ((cellHeight + cellAxisSpace) * ((value.showProducts.length + 1) / 2)) + 60,
                child: GridView.builder(
                  controller: _controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: cellAxisSpace,
                    crossAxisSpacing: cellAxisSpace,
                    crossAxisCount: 2,
                    childAspectRatio: cellWidth / cellHeight,
                  ), 
                  itemCount: value.showProducts.length,
                  itemBuilder: (context, index) {
                    Product product = value.showProducts[index];
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/product',
                            arguments: ProductInfoArguments(product)
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 0)
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: cellWidth - 8 - 2, height: cellWidth - 8 - 2,
                                child: Image.network(product.image, fit: BoxFit.contain,),
                              ),
                      
                              SizedBox(height: 4),
                              Text(product.title,
                                style: GoogleFonts.notoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text("⭐️ ${product.rating.rate} / 🛒 ${product.rating.count}",
                                    style: GoogleFonts.notoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text("\$ ${product.price}",
                                    style: GoogleFonts.notoSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                      ),
                    );
                  },
                ),
              ),
              value.isLoading ? CircleProgerssIndicator(): Container(),
            ],
          )
        );
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(nextLoad);
    super.dispose();
  }

  void nextLoad() async{
    NetworkManager nm = NetworkManager();
    ProductsService service = context.read<ProductsService>();
    //controller.position.extentAfter 스크롤 남은 영역 크기
    if(_controller.position.extentAfter < 50 && service.showProducts.length < service.receivedProducts.length){
      service.addMoreProducts();
    }
  }
}

circleAppBarButton({required Widget child}){
  return Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CsColors.cs.darkAccentColor.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(1, 1)
          )
        ],
    ),
    child: child,
  );
}