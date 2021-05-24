import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/cctv_list_resp.dart';

class CctvListTile extends StatelessWidget {
  final CctvMinResponse data;

  const CctvListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(data.name),
            subtitle: Row(
              children: [
                Text(data.ip.toLowerCase()),
              ],
            ),
            trailing: Text("${data.location}")));
  }
}
