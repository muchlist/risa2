import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/router/routes.dart';

import '../../config/pallatte.dart';
import '../../providers/computers.dart';
import '../../shared/other_item_action_widget.dart';
import '../../shared/ui_helpers.dart';

class ComputerWithIncidentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final computerExtraList =
        context.read<ComputerProvider>().computerExtraList;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: screenHeightPercentage(context, percentage: 0.8),
      child: Column(children: [
        const Divider(
          height: 40,
          thickness: 5,
          color: Pallete.secondaryBackground,
          indent: 50,
          endIndent: 50,
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: const Text(
                      " Komputer bermasalah :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((contex, index) {
                    return GestureDetector(
                      onTap: () {
                        // context.read<ComputerProvider>().removeDetail();
                        // context
                        //     .read<ComputerProvider>()
                        //     .setComputerID(computerExtraList[index].id);
                        // Navigator.pushNamed(context, RouteGenerator.computerDetail);
                      },
                      child: OtherActionTile(data: computerExtraList[index]),
                    );
                  }, childCount: computerExtraList.length),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
