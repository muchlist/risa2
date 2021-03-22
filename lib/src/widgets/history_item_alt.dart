import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: ListTile(
        leading: Icon(CupertinoIcons.camera_circle),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "Lorem Ipsum sir dolor amet",
            style: TextStyle(fontSize: 18),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lorem ipsum sir dolor amet\n # Lorem ipsum sir dolor amet"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 186, 130, 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Progress",
                      style: TextStyle(color: Color.fromRGBO(255, 186, 130, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("12 Feb"),
                SizedBox(
                  width: 10,
                ),
                Text("By Hendra")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
