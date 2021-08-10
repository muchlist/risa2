import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/improves.dart';
import '../../shared/ui_helpers.dart';
import 'corousel_widget.dart';

class CorouselContainer extends StatefulWidget {
  const CorouselContainer();

  @override
  _CorouselContainerState createState() => _CorouselContainerState();
}

class _CorouselContainerState extends State<CorouselContainer> {
  @override
  void initState() {
    Future<void>.delayed(Duration.zero, () {
      context.read<ImproveProvider>().findImprove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ImproveProvider improveProvider = context.watch<ImproveProvider>();

    return Center(
        child: (improveProvider.improveListFront.isNotEmpty)
            ? SizedBox(
                width: double.infinity,
                child: Corousel(improveProvider.improveListFront),
              )
            : verticalSpaceMedium);
  }
}
