import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/auth.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authModel = Provider.of<AuthModel>(context, listen: false);

    return SafeArea(
      child: Consumer<AuthModel>(
        builder: (context, value, child) => Center(
            child: Column(
          children: [
            Text(value.userData?.accessToken ?? ""),
            Text((value.error ?? "")),
            ElevatedButton(
                onPressed: () {
                  authModel.login("1191122712asd", "Pelindo34d");
                },
                child: Text("picik aku"))
          ],
        )),
      ),
    );
  }
}
