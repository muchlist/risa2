import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../providers/others.dart';
import '../../router/routes.dart';
import '../../shared/other_item_action_widget.dart';
import '../../shared/ui_helpers.dart';

class OtherWithIncidentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final otherProvider = context.read<OtherProvider>();
    final otherExtraList = otherProvider.otherExtraList;

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
                    child: Text(
                      " ${otherProvider.subCategory} bermasalah :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((contex, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<OtherProvider>().removeDetail();
                        context
                            .read<OtherProvider>()
                            .setOtherID(otherExtraList[index].id);
                        Navigator.pushNamed(
                            context, RouteGenerator.otherDetail);
                      },
                      child: OtherActionTile(data: otherExtraList[index]),
                    );
                  }, childCount: otherExtraList.length),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
