import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/config/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/pallatte.dart';
import '../../providers/dashboard.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../utils/utils.dart';

class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Report Generated"),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     icon: Icon(Icons.add),
      //     onPressed: () {
      //       // add pdf , munculkan bottom sheet saja
      //     },
      //     label: Text("Buat Manual")),
      body: PdfRecyclerView(),
    );
  }
}

class PdfRecyclerView extends StatefulWidget {
  @override
  _PdfRecyclerViewState createState() => _PdfRecyclerViewState();
}

class _PdfRecyclerViewState extends State<PdfRecyclerView> {
  final refreshKeyPdfScreen = GlobalKey<RefreshIndicatorState>();

  Future<void> _loadPdf() {
    return Future.delayed(Duration.zero, () {
      context.read<DashboardProvider>().findPdf().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    } else {
      showToastError(context: context, message: "Error saat membuka link pdf!");
    }
  }

  @override
  void initState() {
    _loadPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (_, data, __) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.pdfList.length != 0)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadPdf)
                      : Center()),
          (data.state == ViewState.busy)
              ? Center(child: CircularProgressIndicator())
              : Center(),
        ],
      );
    });
  }

  Widget buildListView(DashboardProvider data) {
    return RefreshIndicator(
      key: refreshKeyPdfScreen,
      onRefresh: _loadPdf,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.pdfList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                final url =
                    "${Constant.baseUrl}${data.pdfList[index].fileName}";
                _launchInBrowser(url);
              },
              child: Card(
                  child: ListTile(
                title: Text(data.pdfList[index].name),
                subtitle: Text(
                    "Dibuat ${data.pdfList[index].createdAt.getCompleteDateString()} oleh ${data.pdfList[index].createdBy.toLowerCase()}"),
                trailing: Icon(
                  Icons.download,
                  color: Pallete.green,
                ),
              )));
        },
      ),
    );
  }
}
