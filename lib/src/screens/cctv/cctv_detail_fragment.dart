import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/cctv_resp.dart';

import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/cctvs.dart';
import '../../router/routes.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/chart_ping.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

class CctvDetailFragment extends StatefulWidget {
  @override
  _CctvDetailFragmentState createState() => _CctvDetailFragmentState();
}

class _CctvDetailFragmentState extends State<CctvDetailFragment> {
  @override
  Widget build(BuildContext context) {
    final CctvProvider cctvProvider = context.watch<CctvProvider>();
    final CctvDetailResponseData detail = cctvProvider.cctvDetail;

    return Stack(children: <Widget>[
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Upper table
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      detail.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: cctvProvider.getDetail,
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2.0),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: <TableRow>[
                    TableRow(children: <Widget>[
                      const Text("IP"),
                      const Text("   :   "),
                      Text(
                        detail.ip,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("No Invent"),
                      const Text("   :   "),
                      Text(
                        detail.inventoryNumber,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Cabang"),
                      const Text("   :   "),
                      Text(
                        detail.branch,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Lokasi"),
                      const Text("   :   "),
                      Text(
                        detail.location,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Merk Tipe"),
                      const Text("   :   "),
                      Text(
                        "${detail.brand} ${detail.type}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Tahun"),
                      const Text("   :   "),
                      if (detail.date != 0)
                        Text(
                          detail.date.getMonthYear(),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        )
                      else
                        const Text(""),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Update"),
                      const Text("   :   "),
                      Text(
                        detail.updatedAt.getDateString(),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Catatan"),
                      const Text("   :   "),
                      Text(
                        detail.note,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                    ])
                  ],
                ),
              ),
              verticalSpaceMedium,

              if (detail.extra.pingsState.isNotEmpty)
                PingLineChart(
                  data: detail.extra,
                ),

              verticalSpaceMedium,
              ButtonContainer(
                provider: cctvProvider,
              ),
            ],
          ),
        ),
      ),
      // Loading Screen
      if (cctvProvider.detailState == ViewState.busy)
        const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }
}

class ButtonContainer extends StatefulWidget {
  const ButtonContainer({required this.provider});
  final CctvProvider provider;

  @override
  _ButtonContainerState createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  late File? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> _getImageAndUpload(
      {required BuildContext context,
      required ImageSource source,
      required String id}) async {
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<CctvProvider>()
        .uploadImage(id, _image!)
        .then((bool value) {
      if (value) {
        showToastSuccess(
            context: context, message: "Berhasil mengupload gambar");
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
    });
  }

  Future<bool?> _deleteConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi hapus"),
            content: const Text("Apakah yakin ingin menghapus cctv ini!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Tidak")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final CctvDetailResponseData detail = widget.provider.cctvDetail;
    return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: <Widget>[
            Container(
              child: (detail.image.isNotEmpty)
                  ? Flexible(
                      child: GestureDetector(
                      onTap: () => _getImageAndUpload(
                          context: context,
                          source: ImageSource.camera,
                          id: detail.id),
                      onLongPress: () => _getImageAndUpload(
                          context: context,
                          source: ImageSource.gallery,
                          id: detail.id),
                      child: CachedImageSquare(
                        urlPath: "${Constant.baseUrl}${detail.image}",
                      ),
                    ))
                  : GestureDetector(
                      onTap: () => _getImageAndUpload(
                          context: context,
                          source: ImageSource.camera,
                          id: detail.id),
                      onLongPress: () => _getImageAndUpload(
                          context: context,
                          source: ImageSource.gallery,
                          id: detail.id),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Pallete.secondaryBackground,
                              borderRadius: BorderRadius.circular(10.0)),
                          width: 100,
                          height: 100,
                          child: const Icon(CupertinoIcons.camera)),
                    ),
            ),
            horizontalSpaceMedium,
            Expanded(
                child: Wrap(
              spacing: 10.0,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteGenerator.cctvEdit);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[300],
                    ),
                    icon: const Icon(CupertinoIcons.pencil_circle),
                    label: const Text("Edit")),
                ElevatedButton.icon(
                    onPressed: () async {
                      final bool? confirmDelete = await _deleteConfirm(context);
                      if (confirmDelete != null && confirmDelete) {
                        await context
                            .read<CctvProvider>()
                            .removeCctv()
                            .then((bool value) {
                          if (value) {
                            Navigator.pop(context);
                            showToastSuccess(
                                context: context,
                                message:
                                    "Berhasil menghapus cctv ${detail.name}");
                          }
                        }).onError((Object? error, _) {
                          showToastError(
                              context: context, message: error.toString());
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[300],
                    ),
                    icon: const Icon(CupertinoIcons.trash_circle),
                    label: const Text("Hapus")),
              ],
            ))
          ],
        ));
  }
}
