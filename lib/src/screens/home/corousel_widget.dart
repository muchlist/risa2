import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/improve_list_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/improves.dart';
import '../../router/routes.dart';

class Corousel extends StatelessWidget {
  const Corousel(this.improves);
  final List<ImproveMinResponse> improves;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 90,
          viewportFraction: 0.70,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          enlargeCenterPage: true,
        ),
        items: improves.map((ImproveMinResponse i) {
          return Builder(
            builder: (BuildContext ctx) {
              return GestureDetector(
                onTap: () {
                  ctx.read<ImproveProvider>().setImproveDataPass(i);
                  Navigator.pushNamed(context, RouteGenerator.improveChange);
                },
                child: CorouselItem(
                  improvePreview: i,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class CorouselItem extends StatelessWidget {
  const CorouselItem({required this.improvePreview});
  final ImproveMinResponse improvePreview;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.blueGrey.shade400,
        shadowColor: Colors.black54,
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Pallete.secondaryBackground, width: 0.2),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(improvePreview.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              subtitle: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    improvePreview.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  )),
                ],
              ),
              trailing: (improvePreview.goal != 0)
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Pallete.green),
                      child: Text(
                        "${(improvePreview.goalsAchieved / improvePreview.goal * 100).toInt()}%",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ))
                  : const SizedBox()),
        ),
      ),
    );
  }
}
