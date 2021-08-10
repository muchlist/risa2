import 'package:flutter/material.dart';

import '../api/json_models/response/general_list_resp.dart';
import '../config/pallatte.dart';

class GeneralListTile extends StatelessWidget {
  const GeneralListTile({Key? key, required this.data}) : super(key: key);
  final GeneralMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
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
                children: <Widget>[
                  if (data.ip == "0.0.0.0")
                    Text.rich(TextSpan(children: <InlineSpan>[
                      TextSpan(
                          text: " ${data.category.toLowerCase()} ",
                          style: const TextStyle(
                              backgroundColor: Pallete.secondaryBackground))
                    ]))
                  else
                    Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: " ${data.category.toLowerCase()} ",
                          style: const TextStyle(
                              backgroundColor: Pallete.secondaryBackground)),
                      TextSpan(text: "  ${data.ip}")
                    ])),
                ],
              ),
              trailing: (data.casesSize != 0)
                  ? Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.pink),
                      child: Text(
                        data.casesSize.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
