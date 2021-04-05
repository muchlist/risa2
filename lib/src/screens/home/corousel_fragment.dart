import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/improves.dart';
import 'corousel_widget.dart';

class CorouselContainer extends StatefulWidget {
  const CorouselContainer();

  @override
  _CorouselContainerState createState() => _CorouselContainerState();
}

class _CorouselContainerState extends State<CorouselContainer> {
  @override
  void initState() {
    context.read<ImproveProvider>().findImprove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final improveProvider = context.watch<ImproveProvider>();

    return Center(
        child: (improveProvider.improveList.length != 0)
            ? Container(
                width: double.infinity,
                child: Corousel(improveProvider.improveList),
              )
            : const SizedBox(
                height: 20,
              ));
  }
}
