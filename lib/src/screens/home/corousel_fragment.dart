import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/home/corousel_widget.dart';
import 'package:risa2/src/screens/home/home_navigation.dart';
import '../../providers/improves.dart';

class CorouselContainer extends StatefulWidget {
  const CorouselContainer();

  @override
  _CorouselContainerState createState() => _CorouselContainerState();
}

class _CorouselContainerState extends State<CorouselContainer> {
  var _initImprove = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_initImprove) {
      context.read<ImproveProvider>().findImprove().onError((error, _) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(scaffoldHomeKey.currentContext!)
            .showSnackBar(snackBar);
      });
      _initImprove = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final improveProvider = context.watch<ImproveProvider>();
    // context.read<ImproveProvider>().addListener(() {
    //   if (improveProvider.error != null) {
    // final snackBar = SnackBar(
    //   content: Text(improveProvider.error ?? ""),
    //   duration: Duration(seconds: 3),
    // );
    // ScaffoldMessenger.of(scaffoldHomeKey.currentContext!)
    //     .showSnackBar(snackBar);
    //     improveProvider.removeError();
    //   }
    // });

    return Center(
        child: (improveProvider.improveList.length != 0)
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                // COROUSEL
                child: Corousel(improveProvider.improveList),
              )
            : SizedBox(
                height: 20,
              ));
  }
}
