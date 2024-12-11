import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

import '../../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../constants/app_constants.dart';
import '../pages/store/store_detailsmenu_model.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<Product>? productList;

  CarouselSliderWidget({super.key, required this.productList});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final carousel_slider.CarouselController _controller =
      carousel_slider.CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.productList == null || widget.productList!.isEmpty) {
      return Center(
        child: Text('No products available'),
      );
    }

    return Column(
      children: [
        carousel_slider.CarouselSlider(
          items: widget.productList!.map((product) {
            final imageUrl =
                product.itemImageUrl != null && product.itemImageUrl!.isNotEmpty
                    ? AppConstants.imgBaseUrl + product.itemImageUrl!
                    : null;

            return GestureDetector(
              onTap: () {
                // Optional: Handle item tap logic
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: imageUrl != null
                    ? FadeInImage.assetNetwork(
                        placeholder: AppAssets.bannerimg, // Placeholder asset
                        image: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppAssets.bannerhome,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0,
                          );
                        },
                      )
                    : Image.asset(
                        AppAssets.bannerhome,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                      ),
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: carousel_slider.CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            enlargeFactor: 0.2,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.productList!.asMap().entries.map((entry) {
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
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
