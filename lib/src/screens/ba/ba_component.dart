import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import '../../api/json_models/response/ba_resp.dart';
import '../../config/constant.dart';
import '../../shared/cached_image_square.dart';
import '../../shared/disable_glow.dart';
import 'ba_widget.dart';

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

SliverToBoxAdapter buildDescParagraphBold(Description desc) {
  return SliverToBoxAdapter(
      child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(
      desc.description,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ));
}

SliverToBoxAdapter buildDivider() {
  return const SliverToBoxAdapter(
      child: Padding(
    padding: EdgeInsets.symmetric(vertical: 3.0),
    child: Divider(
      thickness: 1,
    ),
  ));
}

SliverToBoxAdapter buildDescTable(List<Equipment> equips, BuildContext ctx) {
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
                    width: (screenIsPortrait(ctx)) ? 150 : 200,
                    child: Text(equip.equipmentName),
                  )),
                  DataCell(SizedBox(
                    width: (screenIsPortrait(ctx)) ? 300 : 600,
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

SliverToBoxAdapter buildPhotoList(List<String> photos, int completeStatus) {
  return SliverToBoxAdapter(
      child: SizedBox(
    height: 150,
    child: DisableOverScrollGlow(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: photos.length + 1,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == photos.length) {
            return (completeStatus > 0)
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GestureDetector(
                      // onTap: () {
                      //   _getImageAndUpload(
                      //       context: context,
                      //       source: ImageSource.camera,
                      //       id: data.id);
                      // },
                      // onLongPress: () {
                      //   _getImageAndUpload(
                      //       context: context,
                      //       source: ImageSource.gallery,
                      //       id: data.id);
                      // },
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ));
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              // onLongPress: () async {
              //   if (data.state == 2) {
              //     return;
              //   }
              //   final bool? confirmed = await confirmDialog(
              //       context,
              //       "Menghapus gambar",
              //       "Apakah yakin ingin menghapus gambar ini ?");
              //   if (confirmed != null && confirmed) {
              //     await _deleteImage(data.images[index]);
              //   }
              // },
              child: CachedImageSquare(
                urlPath: "${Constant.baseUrl}${photos[index]}",
                width: 200,
              ),
            ),
          );
        },
      ),
    ),
  ));
}

SliverToBoxAdapter buildSignList(
    List<Participant> participants, int completeStatus) {
  return SliverToBoxAdapter(
      child: SizedBox(
    height: 170,
    child: DisableOverScrollGlow(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: participants.length + 1,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == participants.length) {
            return (completeStatus > 0)
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GestureDetector(
                      // onTap: () {

                      // },
                      // onLongPress: () {

                      // },
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ));
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              // onLongPress: () async {
              // },
              child: BaSignWidget(data: participants[index]),
            ),
          );
        },
      ),
    ),
  ));
}
