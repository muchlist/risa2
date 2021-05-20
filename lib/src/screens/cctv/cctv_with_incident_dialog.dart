import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/general_list_resp.dart';

import '../../config/pallatte.dart';
import '../../providers/cctvs.dart';
import '../../shared/cctv_item_action_widget.dart';

class CctvWithIncidentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.8,
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
                      " Cctv bermasalah :",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((contex, index) {
                    return CctvActionTile(
                        data:
                            context.read<CctvProvider>().cctvExtraList[index]);
                  },
                      childCount:
                          context.read<CctvProvider>().cctvExtraList.length),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
