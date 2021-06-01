import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/improve_list_resp.dart';
import 'package:risa2/src/config/pallatte.dart';

class ImproveListTile extends StatelessWidget {
  final ImproveMinResponse data;

  const ImproveListTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Pallete.secondaryBackground, width: 0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(data.title,
                  style: Theme.of(context).textTheme.bodyText1!),
              subtitle: Text(
                data.description,
              ),
              leading: (!data.isActive)
                  ? Icon(Icons.disabled_by_default_rounded)
                  : null,
              trailing: (data.goal != 0)
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${(data.goalsAchieved / data.goal * 100).toInt()}%",
                        style: TextStyle(fontSize: 10),
                      ))
                  : const SizedBox()),
        ),
      ),
    );
  }
}
