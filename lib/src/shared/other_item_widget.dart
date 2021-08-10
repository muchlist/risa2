import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/other_list_resp.dart';

class OtherListTile extends StatelessWidget {
  const OtherListTile({Key? key, required this.data}) : super(key: key);
  final OtherMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            title: Text(data.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (data.ip.isNotEmpty && data.ip != "0.0.0.0")
                  Text(data.ip.toLowerCase()),
                if (data.detail.isNotEmpty) Text(data.detail),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (data.location.isNotEmpty) Text(data.location.toLowerCase()),
                if (data.division.isNotEmpty) Text(data.division.toLowerCase())
              ],
            )));
  }
}
