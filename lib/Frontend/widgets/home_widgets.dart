import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../constant/images.dart';
import '../constant/color.dart';

TextEditingController _searchController = TextEditingController();

// *Searchbar*
Widget searchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: black, width: 1.0)),
    child: Row(
      children: [
        const Icon(Icons.search),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              enabled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: "Search Items",
            ),
          ),
        ),
      ],
    ),
  );
}

// *Carousel Slider*
Widget automaticSlider() {
  return CarouselSlider(
    options: CarouselOptions(
        height: 150.0, autoPlay: true, clipBehavior: Clip.antiAlias),
    items: carouseImagelList.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: black, width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: AssetImage(i),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}
