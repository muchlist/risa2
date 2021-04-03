import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';
import '../api/json_models/response/general_list_resp.dart';

class GeneralListTile extends StatelessWidget {
  final GeneralMinResponse data;

  const GeneralListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
              title: Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (data.ip == "0.0.0.0")
                      ? Text.rich(TextSpan(children: [
                          TextSpan(
                              text: " ${data.category.toLowerCase()} ",
                              style: TextStyle(
                                  backgroundColor: Pallete.secondaryBackground))
                        ]))
                      : Text.rich(TextSpan(children: [
                          TextSpan(
                              text: " ${data.category.toLowerCase()} ",
                              style: TextStyle(
                                  backgroundColor:
                                      Pallete.secondaryBackground)),
                          TextSpan(text: "  ${data.ip}")
                        ])),
                ],
              ),
              trailing: (data.casesSize != 0)
                  ? Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.pink),
                      child: Text(
                        data.casesSize.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink()),
        ],
      ),
    );
  }
}
