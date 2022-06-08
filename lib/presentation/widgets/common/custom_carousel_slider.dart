import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:money_control/data/models/data_storage.dart';
import 'package:money_control/presentation/widgets/carousel_item.dart';

class CustomCarouselSlider extends StatefulWidget {
  final CarouselController carouselController;
  final int currentSlider;
  final int today;

  const CustomCarouselSlider({
    Key? key,
    required this.carouselController,
    required this.currentSlider,
    required this.today,
  }) : super(key: key);

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  var locCurrentSlider = 0;

  @override
  void initState() {
    locCurrentSlider = widget.currentSlider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      //height: availableHeight * 0.21,
      height: 150.0,
      child: CarouselSlider(
        carouselController: widget.carouselController,
        options: CarouselOptions(
            initialPage: locCurrentSlider,
            viewportFraction: 0.5,
            enlargeCenterPage: false,
            onPageChanged: (index, page) {
              setState(() {
                locCurrentSlider = index;
              });
            }),
        items: dataStorage.appliedCards.length > 0
            ? dataStorage.appliedCards.map((card) {
                return CarouselItem(
                  id: card.id,
                  categoryId: card.categoryId,
                  title: card.title,
                  allMoney: card.allSum,
                  passedMoney: card.passedSum,
                  passedDays: card.currentDay,
                  lastDay: card.lastDay,
                  today: widget.today,
                  bgColor: card.bgColorOne,
                  fgColor: card.fgColor,
                  colorId: card.colorId,
                  isEmpty: false,
                  width: MediaQuery.of(context).size.width,
                );
              }).toList()
            : List.generate(1, (index) {
                return CarouselItem(
                  isEmpty: true,
                  width: MediaQuery.of(context).size.width,
                );
              }).toList(),
      ),
    );
  }
}
