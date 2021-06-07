import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/general_list_resp.dart';
import '../config/pallatte.dart';

class OtherActionTile extends StatelessWidget {
  final GeneralMinResponse data;

  const OtherActionTile({Key? key, required this.data}) : super(key: key);

  double _calculatePercentPing() {
    var pingSum = 0;
    for (final ping in data.pingsState) {
      pingSum += ping.code;
    }
    if (pingSum == 0) {
      return 0.0;
    }
    return (pingSum / 2 / data.pingsState.length * 100);
  }

  String _generateCase() {
    var caseString = "";
    for (final caseItem in data.cases) {
      caseString += caseItem.caseNote + "\n";
    }

    caseString = caseString.replaceAll("#Pending#", "⏱");
    caseString = caseString.replaceAll("#Progress#", "🔧");
    caseString = caseString.replaceAll(" None", "");

    return caseString;
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Pallete.secondaryBackground,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        data.ip.toLowerCase(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  (data.casesSize != 0)
                      ? Text(_generateCase())
                      : const SizedBox.shrink(),
                ],
              ),
              trailing: (data.pingsState.length != 0)
                  ? Text("${_calculatePercentPing().toStringAsFixed(0)}%")
                  : SizedBox.shrink()),
        ));
  }
}
