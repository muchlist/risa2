import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../api/json_models/response/general_list_resp.dart';
import '../config/pallatte.dart';

class CctvActionTile extends StatelessWidget {
  const CctvActionTile({Key? key, required this.data}) : super(key: key);
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

  String _generateCase(List<Case> cases) {
    final StringBuffer caseString = StringBuffer();
    for (final Case caseItem in cases) {
      caseString.writeln(caseItem.caseNote);
    }

    String caseTemp = caseString.toString();
    caseTemp = caseTemp.replaceAll("#Pending#", "⏱");
    caseTemp = caseTemp.replaceAll("#Complete#", "⏱");
    caseTemp = caseTemp.replaceAll("#Progress#", "🔧");
    caseTemp = caseTemp.replaceAll(" None", "");

    return caseTemp;
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
                children: <Widget>[
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
                  if (data.casesSize != 0)
                    Text(_generateCase(data.cases))
                  else
                    Text(
                      "Perangkat perlu pengecekan",
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              trailing: Text("${_calculatePercentPing().toStringAsFixed(0)}%")),
        ));
  }
}
