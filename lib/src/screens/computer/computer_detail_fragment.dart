import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/response/computer_resp.dart';

import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../providers/computers.dart';
import '../../router/routes.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/date_unix.dart';
import '../../utils/enums.dart';

class ComputerDetailFragment extends StatefulWidget {
  @override
  _ComputerDetailFragmentState createState() => _ComputerDetailFragmentState();
}

class _ComputerDetailFragmentState extends State<ComputerDetailFragment> {
  @override
  Widget build(BuildContext context) {
    final ComputerProvider computerProvider = context.watch<ComputerProvider>();
    final ComputerDetailResponseData detail = computerProvider.computerDetail;

    return Stack(children: <Widget>[
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Upper table
              Text(
                detail.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      const Text("Host"),
                      const Text("   :   "),
                      Text(
                        detail.hostname,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
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
                      const Text("Sewa"),
                      const Text("   :   "),
                      Text(
                        (detail.seatManagement) ? "Ya" : "Tidak",
                        softWrap: true,
                        maxLines: 1,
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
              // Bottom table
              const Text(
                "Spesifikasi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: <TableRow>[
                    TableRow(children: <Widget>[
                      const Text("OS"),
                      const Text("   :   "),
                      Text(
                        detail.os,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Prosesor"),
                      const Text("   :   "),
                      Text(
                        detail.processor,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("RAM"),
                      const Text("   :   "),
                      Text(
                        "${detail.ram} MB",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      const Text("Hardisk"),
                      const Text("   :   "),
                      Text(
                        "${detail.hardisk} MB",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                  ],
                ),
              ),

              verticalSpaceMedium,
              ButtonContainer(
                provider: computerProvider,
              ),
            ],
          ),
        ),
      ),
      // Loading Screen
      if (computerProvider.detailState == ViewState.busy)
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
  final ComputerProvider provider;

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
        .read<ComputerProvider>()
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
            content: const Text("Apakah yakin ingin menghapus komputer ini!"),
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
    final ComputerDetailResponseData detail = widget.provider.computerDetail;
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
                      Navigator.pushNamed(context, RouteGenerator.computerEdit);
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
                            .read<ComputerProvider>()
                            .removeComputer()
                            .then((bool value) {
                          if (value) {
                            Navigator.pop(context);
                            showToastSuccess(
                                context: context,
                                message:
                                    "Berhasil menghapus computer ${detail.name}");
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
