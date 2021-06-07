import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
    final computerProvider = context.watch<ComputerProvider>();
    final detail = computerProvider.computerDetail;

    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper table
              Text(
                detail.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: [
                    TableRow(children: [
                      const Text("Host"),
                      const Text("   :   "),
                      Text(
                        detail.hostname,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("IP"),
                      const Text("   :   "),
                      Text(
                        detail.ip,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("No Invent"),
                      const Text("   :   "),
                      Text(
                        detail.inventoryNumber,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Cabang"),
                      const Text("   :   "),
                      Text(
                        detail.branch,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Lokasi"),
                      const Text("   :   "),
                      Text(
                        detail.location,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Merk Tipe"),
                      const Text("   :   "),
                      Text(
                        "${detail.brand} ${detail.type}",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Sewa"),
                      const Text("   :   "),
                      Text(
                        (detail.seatManagement) ? "Ya" : "Tidak",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Tahun"),
                      const Text("   :   "),
                      (detail.date != 0)
                          ? Text(
                              "${detail.date.getMonthYear()}",
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          : Text(""),
                    ]),
                    TableRow(children: [
                      const Text("Update"),
                      const Text("   :   "),
                      Text(
                        detail.updatedAt.getDateString(),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
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
              Text(
                "Spesifikasi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(3.0)
                  },
                  children: [
                    TableRow(children: [
                      const Text("OS"),
                      const Text("   :   "),
                      Text(
                        detail.os,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("Prosesor"),
                      const Text("   :   "),
                      Text(
                        detail.processor,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
                      const Text("RAM"),
                      const Text("   :   "),
                      Text(
                        "${detail.ram} MB",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ]),
                    TableRow(children: [
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
        Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }
}

class ButtonContainer extends StatefulWidget {
  final ComputerProvider provider;

  const ButtonContainer({required this.provider});

  @override
  _ButtonContainerState createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  File? _image;
  final picker = ImagePicker();

  Future _getImageAndUpload(
      {required BuildContext context,
      required ImageSource source,
      required String id}) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<ComputerProvider>()
        .uploadImage(id, _image!)
        .then((value) {
      if (value) {
        showToastSuccess(
            context: context,
            message: "Berhasil mengupload gambar",
            onTop: true);
      }
    }).onError((error, _) {
      showToastError(context: context, message: error.toString());
      return Future.error(error.toString());
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
                  child: const Text("Tidak"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Ya"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.provider.computerDetail;
    return Container(
      child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: (detail.image.isNotEmpty)
                    ? Flexible(
                        flex: 1,
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
                            child: Icon(CupertinoIcons.camera)),
                      ),
              ),
              horizontalSpaceMedium,
              Expanded(
                  flex: 1,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.computerEdit);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[300],
                          ),
                          icon: Icon(CupertinoIcons.pencil_circle),
                          label: const Text("Edit")),
                      ElevatedButton.icon(
                          onPressed: () async {
                            var confirmDelete = await _deleteConfirm(context);
                            if (confirmDelete != null && confirmDelete) {
                              await context
                                  .read<ComputerProvider>()
                                  .removeComputer()
                                  .then((value) {
                                if (value) {
                                  Navigator.pop(context);
                                  showToastSuccess(
                                      context: context,
                                      message:
                                          "Berhasil menghapus computer ${detail.name}");
                                }
                              }).onError((error, _) {
                                showToastError(
                                    context: context,
                                    message: error.toString());
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[300],
                          ),
                          icon: Icon(CupertinoIcons.trash_circle),
                          label: const Text("Hapus")),
                    ],
                  ))
            ],
          )),
    );
  }
}
