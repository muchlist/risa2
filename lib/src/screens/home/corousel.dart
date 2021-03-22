import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/models/improve_preview.dart';

class Corousel extends StatelessWidget {
  var improvementList = [
    ImprovePreview(
        title: "Update IOS PPU Pandu",
        description:
            "Update sebanyak 57 tablet pandu di lingkungan pelindo III",
        progress: 97),
    ImprovePreview(
        title: "Maintnenace UPS",
        description: "Maintenance seluruh perangkat ups",
        progress: 50),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 20),
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
        items: improvementList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return CorouselItem(
                improvePreview: i,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class CorouselItem extends StatelessWidget {
  final ImprovePreview improvePreview;

  const CorouselItem({required this.improvePreview});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    improvePreview.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                    child: Text(improvePreview.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
            trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${improvePreview.progress}%",
                  style: TextStyle(fontSize: 10),
                )),
          ),
        ),
      ),
    );
  }
}
