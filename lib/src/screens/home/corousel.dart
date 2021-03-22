import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Corousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 100,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return CorouselItem();
            },
          );
        }).toList(),
      ),
    );
  }
}

class CorouselItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text("Hayuu"),
          subtitle: Text("mo,okloonoioijio"),
          trailing: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                shape: BoxShape.circle,
              ),
              child: Text(
                "80%",
                style: TextStyle(fontSize: 10),
              )),
        ),
      ),
    );
  }
}
