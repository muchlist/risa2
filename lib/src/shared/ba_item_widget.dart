import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/ba_list_resp.dart';
import '../utils/utils.dart';

class BaListTile extends StatelessWidget {
  const BaListTile({Key? key, required this.data}) : super(key: key);
  final BaMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(data.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.deepOrange.shade50,
                    ),
                    child: Text(" ${data.number} ")),
                Text(data.date.getDateWithYearString() + " ${data.createdBy}"),
              ],
            ),
          ),
        ));
  }
}
