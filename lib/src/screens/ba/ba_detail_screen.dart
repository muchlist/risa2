import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/ba_resp.dart';

import '../../config/pallatte.dart';
import '../../providers/ba_provider.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../utils/enums.dart';

GlobalKey<RefreshIndicatorState> refreshKeyBaDetailScreen =
    GlobalKey<RefreshIndicatorState>();

class BaDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Detail Berita Acara"),
        ),
        body: BaDetailBody());
  }
}

class BaDetailBody extends StatefulWidget {
  @override
  _BaDetailBodyState createState() => _BaDetailBodyState();
}

class _BaDetailBodyState extends State<BaDetailBody> {
  late BaProvider _baProviderR;

  @override
  void initState() {
    _baProviderR = context.read<BaProvider>();
    _baProviderR.removeDetail();
    _loadDetail();
    super.initState();
  }

  Future<void> _loadDetail() {
    return Future<void>.delayed(Duration.zero, () {
      _baProviderR.getDetail().onError((Object? error, _) {
        Navigator.pop(context);
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch data ====================================================
    final BaProvider data = context.watch<BaProvider>();

    return (data.detailState == ViewState.busy)
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            // ================================================== Stack
            children: <Widget>[
              buildBody(data),
            ],
          );
  }

  Widget buildBody(BaProvider data) {
    final BaDetailResponseData detail = data.baDetail;
    final List<Description> sortedDesc = detail.descriptions;
    sortedDesc.sort(
        (Description a, Description b) => a.position.compareTo(b.position));

    // ===============================================================Insertion Sliver
    final List<Widget> slivers = <Widget>[
      buildTitleSliver(detail),
    ];

    for (final Description desc in detail.descriptions) {
      switch (desc.descriptionType) {
        case "paragraph":
          slivers.add(buildDescParagraph(desc));
          break;
        case "equip":
          slivers.add(buildDescTable(detail.equipments));
          break;
        case "bullet":
          slivers.add(buildNumberedText(desc));
          break;
        default:
          slivers.add(buildDescParagraph(desc));
      }
    }

    // end sliver
    slivers.add(const SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
      ),
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        key: refreshKeyBaDetailScreen,
        onRefresh: _loadDetail,
        child: DisableOverScrollGlow(
          child: CustomScrollView(slivers: slivers),
        ),
      ),
    );
  }

  // ======================================================================== List Item body start here
  SliverToBoxAdapter buildTitleSliver(BaDetailResponseData data) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(3)),
        child: Column(
          children: <Widget>[
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "nomor : ${data.number}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildDescParagraph(Description desc) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(desc.description),
    ));
  }

  SliverToBoxAdapter buildDescTable(List<Equipment> equips) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.grey.withOpacity(0.5); // Use the default value.
          }),
          dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.yellow.shade50; // Use the default value.
          }),
          columnSpacing: 30.0,
          dataRowHeight: 60.0,
          columns: const <DataColumn>[
            DataColumn(label: Text("Nama")),
            DataColumn(label: Text("Keterangan")),
            DataColumn(label: Text("Jumlah"), numeric: true),
          ],
          rows: equips
              .map((Equipment equip) => DataRow(cells: <DataCell>[
                    DataCell(SizedBox(
                      width: 100,
                      child: Text(equip.equipmentName),
                    )),
                    DataCell(SizedBox(
                      width: 300,
                      child: Text(equip.description),
                    )),
                    DataCell(Text("${equip.qty}"))
                  ]))
              .toList(),
        ),
      ),
    ));
  }

  SliverList buildNumberedText(Description desc) {
    final String textDesc = desc.description;
    final List<String> textList = textDesc.split("||");

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(" ${index + 1}    "),
                Flexible(
                    child: Text(
                  textList[index],
                )),
              ],
            ),
          );
        },
        childCount: textList.length, // 1000 list items
      ),
    );
  }
}
