import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/computer_list_resp.dart';
import 'ui_helpers.dart';

class ComputerListTile extends StatelessWidget {
  const ComputerListTile({Key? key, required this.data}) : super(key: key);
  final ComputerMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            title: Text(data.name),
            subtitle: Row(
              children: <Widget>[
                if (data.seatManagement)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green.shade100,
                    ),
                    child: const Text(" Seat "),
                  ),
                if (data.seatManagement) horizontalSpaceTiny,
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.deepOrange.shade50,
                    ),
                    child: Text(" ${data.ip.toLowerCase()} ")),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data.location.toLowerCase()),
                Text(data.division.toLowerCase())
              ],
            )));
  }
}
