import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import '../api/json_models/response/computer_list_resp.dart';

class ComputerListTile extends StatelessWidget {
  final ComputerMinResponse data;

  const ComputerListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            title: Text(data.name),
            subtitle: Row(
              children: [
                if (data.seatManagement)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green.shade100,
                    ),
                    child: Text(" Seat "),
                  ),
                if (data.seatManagement) horizontalSpaceTiny,
                Text(data.ip.toLowerCase()),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.location.toLowerCase()),
                Text(data.division.toLowerCase())
              ],
            )));
  }
}
