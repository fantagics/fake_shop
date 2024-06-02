import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../color_asset/colors.dart';
import '../service/products_service.dart';
import './sub/circle_progress_indicator_widget.dart';
import '../network/network_manager.dart';
import '../model/translation_ko.dart';
import '../model/products.dart';
import '../model/arguments/product_info_arguments.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int eventIdx = 0;
  NetworkManager nm = NetworkManager();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductsService service = context.read<ProductsService>();
    service.changeLoadState(true);
    nm.getBestItemEachCategory(context: context);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsService>(
      builder: (context, value, child) {
        double imgLength = MediaQuery.of(context).size.width / 5;
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 16/9,
                            initialPage: 0,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 5),
                            onPageChanged: (index, reason) {
                              setState(() {
                                eventIdx  = index;
                              });
                            },
                          ),
                          itemCount: value.eventsImg.length,
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () { print(index); },
                              child: Image.asset(value.eventsImg[index]),
                            );
                          },
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10),
                          child: AnimatedSmoothIndicator(
                            activeIndex: eventIdx, 
                            count: value.eventsImg.length,
                            effect: WormEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              dotColor: Colors.grey.withOpacity(0.6),
                              activeDotColor: CsColors.cs.accentColor
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: ((imgLength + 101) * 4) + 60,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: value.categories.length,
                        itemBuilder: (context, index) {
                          String category = value.categories[index];
                          List<Product> products = value.recommend[category] ?? [];
                          return products.length != 3 ? Container() : ListTile(
                            title: Text(CategoryKo[category] ?? category,
                              style: GoogleFonts.notoSans(
                                color: Colors.black
                              ),
                            ),
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                previewMiniProduct(context: context, imgLength: imgLength, product: products[0]),
                                Expanded(child: Container(),),
                                previewMiniProduct(context: context, imgLength: imgLength, product: products[1]),
                                Expanded(child: Container(),),
                                previewMiniProduct(context: context, imgLength: imgLength, product: products[2]),
                                Expanded(child: Container(),),
                                GestureDetector(
                                  onTap: (){
                                    value.selectedCategory = category;
                                    Navigator.pushNamed(context, '/productsList');
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey
                                          ),
                                          width: imgLength - 20, height: imgLength - 20,
                                          child: Icon(Icons.add, color: Colors.black,)
                                        ),
                                      ),
                                      Text("더 보기\n\n",
                                        style: GoogleFonts.notoSans(
                                          fontSize: 14,
                                          color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              value.isLoading ? CircleProgerssIndicator(): Container(),
            ]
          )
        );
      }
    );
  }
}

previewMiniProduct({
  required BuildContext context,
  required Product product,
  required double imgLength
}){
  return Container(
    width: imgLength,
    child: GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/product',
        arguments: ProductInfoArguments(product)
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: imgLength - 20, height: imgLength - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  )
                ]
              ),
              child: Image.network(product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(product.title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.black
            ),
          ),
          Text("\$${product.price}",
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.black
            ),
          ),
          Text("⭐️ ${product.rating.rate} / 🛒 ${product.rating.count}",
            style: GoogleFonts.notoSans(
              fontSize: 10
            ),
          ),
        ],
      ),
    ),
  );
}