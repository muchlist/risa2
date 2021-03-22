import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              row1,
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("CCTV mati perlu pengecekan oleh vendor ke atas,"),
                  Text("Penggantian lan dan poe oleh multinet")
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 186, 130, 0.15),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Progress",
                        style:
                            TextStyle(color: Color.fromRGBO(255, 186, 130, 1)),
                      ),
                    ),
                  ),
                  Text("45 minutes"),
                  Text("By hendra"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Row row1 =
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
  RichText(
      text: TextSpan(children: [
    WidgetSpan(child: Icon(Icons.camera)),
    WidgetSpan(
        child: SizedBox(
      width: 8,
    )),
    TextSpan(
        text: "SP CY2 BLOK-C-013",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18))
  ])),
  Text(
    "12 Feb 2021",
  )
]);
