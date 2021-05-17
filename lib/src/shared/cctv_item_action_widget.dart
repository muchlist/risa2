import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/general_list_resp.dart';

class CctvActionTile extends StatelessWidget {
  final GeneralMinResponse data;

  const CctvActionTile({Key? key, required this.data}) : super(key: key);

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.deepOrange, width: 1)),
        child: ListTile(
            title: Text(data.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.ip.toLowerCase()),
                (data.casesSize != 0)
                    ? Text(_generateCase())
                    : const Text("🔍 : Cctc down, perlu dilakukan pengecekan"),
              ],
            ),
            trailing: Text("${_calculatePercentPing().toStringAsFixed(0)}%")));
  }
}
