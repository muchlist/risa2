import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../config/constant.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/dashboard.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';
import 'generate_pdf_dialog.dart';

class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late final bool _isVendor = App.getRoles().contains("VENDOR");

  void _startGeneratePDF(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const GeneratePdfDialog(),
    );
  }

  void _generatePdfAuto({bool forVendor = false}) {
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<DashboardProvider>()
                .generatePDFAuto(forVendor)
                .then((bool value) {
              if (value) {
                showToastSuccess(
                    context: context, message: "Berhasil membuat pdf");
              }
            }).onError((Object? error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  // void _generatePdfDailyVendor() {
  //   Future<void>.delayed(
  //       Duration.zero,
  //       () => context
  //               .read<DashboardProvider>()
  //               .generatePDFdaily()
  //               .then((bool value) {
  //             if (value) {
  //               showToastSuccess(
  //                   context: context, message: "Berhasil membuat pdf");
  //             }
  //           }).onError((Object? error, _) {
  //             if (error != null) {
  //               showToastError(context: context, message: error.toString());
  //             }
  //           }));
  // }

  Future<void> _loadAllPdf() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<DashboardProvider>().findPdf().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Report Generated"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                CupertinoIcons.text_append,
                size: 26,
              ),
              onPressed: _loadAllPdf),
          horizontalSpaceSmall,
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(child: PdfRecyclerView()),
          Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: HomeLikeButton(
                    iconData: CupertinoIcons.printer,
                    text: _isVendor ? "Daily PDF" : "Generate PDF",
                    tapTap: () {
                      _generatePdfAuto(forVendor: _isVendor);
                    }),
              )),
          Positioned(
            bottom: 30,
            right: 40,
            child: IconButton(
                icon: const Icon(CupertinoIcons.ant_circle, size: 28),
                onPressed: () => _startGeneratePDF(context)),
          ),
        ],
      ),
    );
  }
}

class PdfRecyclerView extends StatefulWidget {
  @override
  _PdfRecyclerViewState createState() => _PdfRecyclerViewState();
}

class _PdfRecyclerViewState extends State<PdfRecyclerView> {
  double _downloadProgress = 0.0;

  final GlobalKey<RefreshIndicatorState> refreshKeyPdfScreen =
      GlobalKey<RefreshIndicatorState>();
  late final bool _isVendor = App.getRoles().contains("VENDOR");

  Future<void> _loadPdf() {
    final String typePDF = _isVendor ? "VENDOR" : "LAPORAN";
    return Future<void>.delayed(Duration.zero, () {
      context
          .read<DashboardProvider>()
          .findPdf(pdfType: typePDF)
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  Future<void> download(Dio dio, String url, String savePath) async {
    try {
      final Response<List<int>> response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (int? status) {
              if (status != null) {
                return status < 500;
              }
              return false;
            }),
      );
      final File file = File(savePath);
      final RandomAccessFile raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data!);
      await raf.close();
    } catch (e) {
      showToastError(context: context, message: e.toString());
      return;
    }
    setState(() {
      _downloadProgress = 0.0;
    });

    OpenFile.open(savePath);
  }

  void showDownloadProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _downloadProgress = received / total;
      });
    }
  }

  @override
  void initState() {
    _loadPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (_, DashboardProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.pdfList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadPdf)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
          if (_downloadProgress != 0.0)
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: LinearProgressIndicator(
                    value: _downloadProgress,
                    color: Colors.deepOrange,
                  ),
                ))
        ],
      );
    });
  }

  Widget buildListView(DashboardProvider data) {
    return RefreshIndicator(
      key: refreshKeyPdfScreen,
      onRefresh: _loadPdf,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.pdfList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                final String url =
                    "${Constant.baseUrl}${data.pdfList[index].fileName}";
                final String fileName =
                    data.pdfList[index].fileName.split("/").last;
                final Directory tempDir = await getTemporaryDirectory();
                final String fullPath = tempDir.path + "/$fileName";
                // _launchInBrowser(url); todo
                download(Dio(), url, fullPath);
              },
              child: Card(
                  child: ListTile(
                title: Text(data.pdfList[index].name),
                subtitle: Text(
                    "Dibuat ${data.pdfList[index].createdAt.getCompleteDateString()} oleh ${data.pdfList[index].createdBy.toLowerCase()}"),
                trailing: Icon(
                  Icons.download,
                  color: (data.pdfList[index].type == "VENDOR")
                      ? Colors.deepOrange[400]
                      : Pallete.green,
                ),
              )));
        },
      ),
    );
  }
}
