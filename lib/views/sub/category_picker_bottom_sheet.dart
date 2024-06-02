import 'package:fake_shop_project/color_asset/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/products_service.dart';
import '../../model/translation_ko.dart';
import '../../network/network_manager.dart';

class CategoryPickerBottomSheet extends StatefulWidget {
  const CategoryPickerBottomSheet({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<CategoryPickerBottomSheet> createState() => _CategoryPickerBottomSheetState();
}

class _CategoryPickerBottomSheetState extends State<CategoryPickerBottomSheet> {
  List<String> categories = ['all'];
  int initalIdx = 0;
  FixedExtentScrollController _controller = FixedExtentScrollController();
  NetworkManager nm = NetworkManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductsService service = context.read<ProductsService>();
    categories += service.categories;
    initalIdx = categories.indexWhere((element) => element == service.selectedCategory);
    _controller = FixedExtentScrollController(initialItem: initalIdx == -1 ? 0 : initalIdx);
  }

  @override
  Widget build(BuildContext context) {
    ProductsService service = context.read<ProductsService>();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).padding.bottom
      ),
      child: SizedBox(
        height: (MediaQuery.of(context).size.height * 2 / 7) + 34 + 8 + 8 + 42,
        child: Column(
          children: [
            Text('카테고리',
              style: GoogleFonts.notoSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 7,
              child: CupertinoPicker(
                selectionOverlay: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CsColors.cs.accentColor.withOpacity(0.2)
                    ),
                  ),
                ),
                scrollController: _controller,
                itemExtent: 50,
                onSelectedItemChanged: (idx){},
                children: categories.map((e){
                  return Center(
                    child: Text( CategoryKo[e] ?? e,
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        color: CsColors.cs.darkAccentColor
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 42,
              child: GestureDetector(
                onTap: (){
                  String selected = _controller.selectedItem == 0 ? 'all' : service.categories[_controller.selectedItem - 1];
                  service.sortType = SortType.recent;
                  Navigator.pop(context);
                  service.getInitalProducts(selected);
                  widget.controller.jumpTo(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CsColors.cs.accentColor,
                  ),
                  child: Center(
                    child: Text('적용하기',
                      style: GoogleFonts.notoSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}