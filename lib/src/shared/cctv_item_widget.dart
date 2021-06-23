import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/cctv_list_resp.dart';

class CctvListTile extends StatelessWidget {
  final CctvMinResponse data;

  const CctvListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            title: Text(data.name),
            subtitle: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.deepOrange.shade50,
                    ),
                    child: Text(" ${data.ip.toLowerCase()} ")),
              ],
            ),
            trailing: Text("${data.location}")));
  }
}
