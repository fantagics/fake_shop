import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../service/products_service.dart';
import './sub/circle_progress_indicator_widget.dart';
import '../network/network_manager.dart';
import '../model/products.dart';
import './sub/banner_autoslider.dart';
import './sub/best_Items_in_category_listtile.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  NetworkManager nm = NetworkManager();
  
  @override
  void initState() {
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
              RefreshIndicator(
                onRefresh: () => refreshAction(context: context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerAutoSlider(),
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
                            return products.length != 3 ? Container() : BestItemsInCategoryListTile(category: category, products: products, imgLength: imgLength);
                          },
                        ),
                      )
                    ],
                  ),
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

Future<void> refreshAction({required BuildContext context}) async{
  ProductsService service = context.read<ProductsService>();
  NetworkManager nm = NetworkManager();
  service.changeLoadState(true);
  nm.getBestItemEachCategory(context: context);
}

