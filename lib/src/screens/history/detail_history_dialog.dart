import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/shared/home_like_button.dart';

import '../../api/json_models/response/history_list_resp.dart';
import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class DetailHistoryDialog extends StatefulWidget {
  final HistoryMinResponse history;

  const DetailHistoryDialog({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  _DetailHistoryDialogState createState() => _DetailHistoryDialogState();
}

class _DetailHistoryDialogState extends State<DetailHistoryDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeightPercentage(context, percentage: 0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 40,
              thickness: 5,
              color: Pallete.secondaryBackground,
              indent: 50,
              endIndent: 50,
            ),
            verticalSpaceSmall,
            Expanded(
                child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Incident",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    verticalSpaceSmall,

                    // * Pilih perangkat text ------------------------
                    const Text(
                      "Perangkat / Software :",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration:
                          BoxDecoration(color: Pallete.secondaryBackground),
                      child: Text(
                        widget.history.parentName,
                      ),
                    ),

                    verticalSpaceSmall,

                    const Text(
                      "Kategori :",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration:
                          BoxDecoration(color: Pallete.secondaryBackground),
                      child: Text(
                        widget.history.category,
                      ),
                    ),

                    verticalSpaceSmall,

                    // * Problem text ------------------------
                    const Text(
                      "Problem",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      enabled: false,
                      initialValue: widget.history.problem,
                      maxLines: null,
                      minLines: null,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                    ),

                    verticalSpaceSmall,

                    // * Status pekerjaan text ------------------------
                    Text(
                      "Status pekerjaan (${enumStatus.values[widget.history.completeStatus].toShortString()})",
                      style: TextStyle(fontSize: 16),
                    ),
                    Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      value: widget.history.completeStatus.toDouble(),
                      label: enumStatus.values[widget.history.completeStatus]
                          .toShortString(),
                      onChanged: (_) {},
                    ),

                    verticalSpaceSmall,

                    // * ResolveNote text ------------------------
                    (widget.history.completeStatus.toDouble() == 4.0)
                        ? const Text(
                            "Resolve Note",
                            style: TextStyle(fontSize: 16),
                          )
                        : const SizedBox.shrink(),

                    (widget.history.completeStatus.toDouble() == 4.0)
                        ? TextFormField(
                            textInputAction: TextInputAction.newline,
                            initialValue: widget.history.problemResolve,
                            enabled: false,
                            maxLines: null,
                            minLines: null,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Pallete.secondaryBackground,
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none),
                          )
                        : const SizedBox.shrink(),
                    verticalSpaceRegular,
                    if (widget.history.image.isNotEmpty)
                      Center(
                        child: CachedImageSquare(
                          urlPath: "${Constant.baseUrl}${widget.history.image}",
                          width: 200,
                          height: 200,
                        ),
                      ),

                    verticalSpaceSmall,

                    // * Problem text ------------------------
                    const Text(
                      "Cabang",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      enabled: false,
                      initialValue: widget.history.branch,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                    ),

                    verticalSpaceSmall,

                    // * Problem text ------------------------
                    const Text(
                      "Dibuat / diupdate oleh",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      enabled: false,
                      initialValue: (widget.history.createdBy ==
                              widget.history.updatedBy)
                          ? widget.history.createdBy
                          : "${widget.history.createdBy} / ${widget.history.updatedBy}",
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                    ),

                    verticalSpaceSmall,

                    // * Problem text ------------------------
                    const Text(
                      "Dibuat pada",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      enabled: false,
                      initialValue:
                          widget.history.createdAt.getCompleteDateString(),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                    ),

                    verticalSpaceSmall,

                    // * Problem text ------------------------
                    const Text(
                      "Terakhir diupdate",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      enabled: false,
                      initialValue:
                          widget.history.updatedAt.getCompleteDateString(),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                    ),

                    verticalSpaceMedium,

                    Center(
                      child: HomeLikeButton(
                          iconData: CupertinoIcons.xmark_circle,
                          text: " Tutup",
                          tapTap: () => Navigator.pop(context)),
                    ),

                    SizedBox(
                      height: screenHeightPercentage(context, percentage: 0.4),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
