import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../color_asset/colors.dart';
import '../../service/products_service.dart';
import '../../model/translation_ko.dart';

class SortTypePickerBottomSheet extends StatefulWidget {
  const SortTypePickerBottomSheet({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<SortTypePickerBottomSheet> createState() => _SortTypePickerBottomSheetState();
}

class _SortTypePickerBottomSheetState extends State<SortTypePickerBottomSheet> {
  FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductsService service = context.read<ProductsService>();
    _controller = FixedExtentScrollController(initialItem: service.sortType.idx);
  }

  @override
  Widget build(BuildContext context) {
    ProductsService service = context.read<ProductsService>();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        height: 330,
        child: Column(
          children: [
            SizedBox(
              height: 250,
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
                children: [0,1,2,3,4].map((e){
                  return Center(
                    child: Text(sortTypeKo[SortType.getByIndex(e).str] ?? SortType.getByIndex(e).str,
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
                onTap: () async{
                  service.sortType = SortType.getByIndex(_controller.selectedItem);
                  service.changeLoadState(true);
                  service.sortAndFilterProducts();
                  Navigator.pop(context);
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