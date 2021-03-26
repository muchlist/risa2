import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/home/corousel_widget.dart';
import '../../providers/improves.dart';

class CorouselContainer extends StatefulWidget {
  const CorouselContainer();

  @override
  _CorouselContainerState createState() => _CorouselContainerState();
}

class _CorouselContainerState extends State<CorouselContainer> {
  @override
  void initState() {
    final improveProvider = context.read<ImproveProvider>();
    // ignore: cascade_invocations
    improveProvider.findImprove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final improveProvider = context.watch<ImproveProvider>();
    final improves = improveProvider.improveList;
    final error = improveProvider.error;

    context.read<ImproveProvider>().addListener(() {
      if (error != null) {
        final snackBar = SnackBar(
          content: Text(error),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        improveProvider.removeError();
      }
    });

    return Center(
        child: (improves.length != 0)
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
                child: Corousel(improves),
              )
            : SizedBox(
                height: 20,
              ));
  }
}
