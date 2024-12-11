import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../constants/app_constants.dart';
import '../pages/models/banner_list_model.dart';

class SliderAdWidget extends StatefulWidget {
  List<BannerListData>? adList;

  SliderAdWidget({super.key, required this.adList});

  @override
  State<SliderAdWidget> createState() => _SliderAdWidgetState();
}

class _SliderAdWidgetState extends State<SliderAdWidget> {
  //final CarouselController _controller = CarouselController();
  final carousel_slider.CarouselController _controller =
      carousel_slider.CarouselController();

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        carousel_slider.CarouselSlider(
          items: widget.adList!
              .map(
                (e) => GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(AppConstants.imgBaseUrl + e.imageUrl!,
                        fit: BoxFit.fill, errorBuilder: (BuildContext context,
                            Object exception, StackTrace? stackTrace) {
                      return Image.asset(
                        AppAssets.bannerhome,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        height: 60.0,
                      );
                    }),
                  ),
                ),
              )
              .toList(),
          carouselController: _controller,
          options: carousel_slider.CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 3.0,
              enlargeFactor: 0.2,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.adList!.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.light
                            : AppColors.dark)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
