import 'package:flutter/material.dart';
import '../api/json_models/response/history_list_resp.dart';
import '../config/constant.dart';
import '../config/histo_icon.dart';
import '../globals.dart';
import '../utils/utils.dart';

import 'cached_image_square.dart';

class HistoryVListTile extends StatelessWidget {
  const HistoryVListTile({Key? key, required this.history}) : super(key: key);
  final HistoryMinResponse history;

  @override
  Widget build(BuildContext context) {
    final _currentUser = App.getName();
    final _createdByCurrentAccount =
        history.createdBy == _currentUser || history.updatedBy == _currentUser;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: _createdByCurrentAccount
              ? Border.all(
                  color: Colors.blue.shade400.withOpacity(0.9), width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (history.image.isNotEmpty)
                CachedImageSquare(
                  urlPath: "${Constant.baseUrl}${history.image.thumbnailMod()}",
                  width: double.infinity,
                ),
              const SizedBox(
                height: 5,
              ),
              Text(history.parentName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(history.problem,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100, color: Colors.grey))),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    getIcon(history.category),
                    color: Colors.grey,
                    size: 14,
                  ),
                  const Spacer(),
                  Text(
                    history.updatedAt.getCompleteDateString(),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
