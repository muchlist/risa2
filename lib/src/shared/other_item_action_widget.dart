import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/general_list_resp.dart';
import '../config/pallatte.dart';

class OtherActionTile extends StatelessWidget {
  const OtherActionTile({Key? key, required this.data}) : super(key: key);
  final GeneralMinResponse data;

  double _calculatePercentPing() {
    int pingSum = 0;
    for (final PingState ping in data.pingsState) {
      pingSum += ping.code;
    }
    if (pingSum == 0) {
      return 0.0;
    }
    return pingSum / 2 / data.pingsState.length * 100;
  }

  String _generateCase() {
    final StringBuffer caseString = StringBuffer();
    for (final Case caseItem in data.cases) {
      caseString.writeln(caseItem.caseNote);
    }

    return caseString.toString()
      ..replaceAll("#Pending#", "⏱")
      ..replaceAll("#Progress#", "🔧")
      ..replaceAll(" None", "");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Pallete.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListTile(
              title: Text(
                data.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.ip.isNotEmpty && data.ip != "0.0.0.0")
                    Container(
                      decoration: BoxDecoration(
                          color: Pallete.secondaryBackground,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          data.ip.toLowerCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  Text(_generateCase())
                ],
              ),
              trailing: (data.pingsState.isNotEmpty)
                  ? Text("${_calculatePercentPing().toStringAsFixed(0)}%")
                  : const SizedBox.shrink()),
        ));
  }
}
