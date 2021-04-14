import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../api/json_models/response/improve_list_resp.dart';
import '../../config/pallatte.dart';

class Corousel extends StatelessWidget {
  final List<ImproveMinResponse> improves;

  const Corousel(this.improves);

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
        items: improves.map((i) {
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
  final ImproveMinResponse improvePreview;

  const CorouselItem({required this.improvePreview});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Pallete.secondaryBackground, width: 0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(improvePreview.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!),
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
              trailing: (improvePreview.goal != 0)
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${improvePreview.goalsAchieved / improvePreview.goal * 100}%",
                        style: TextStyle(fontSize: 10),
                      ))
                  : const SizedBox()),
        ),
      ),
    );
  }
}
