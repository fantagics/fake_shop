import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../color_asset/colors.dart';
import '../../service/products_service.dart';

class BannerAutoSlider extends StatefulWidget {
  const BannerAutoSlider({super.key});

  @override
  State<BannerAutoSlider> createState() => _BannerAutoSliderState();
}

class _BannerAutoSliderState extends State<BannerAutoSlider> {
  int eventIdx = 0;

  @override
  Widget build(BuildContext context) {
    ProductsService service = context.read<ProductsService>();
    return Stack(
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
          itemCount: service.eventsImg.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () { print(index); },
              child: Image.asset(service.eventsImg[index]),
            );
          },
        ),
        Padding(padding: EdgeInsets.only(bottom: 10),
          child: AnimatedSmoothIndicator(
            activeIndex: eventIdx, 
            count: service.eventsImg.length,
            effect: WormEffect(
              dotWidth: 10,
              dotHeight: 10,
              dotColor: Colors.grey.withOpacity(0.6),
              activeDotColor: CsColors.cs.accentColor
            ),
          ),
        ),
      ],
    );
  }
}