import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/ba_resp.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/ba_provider.dart';
import '../../router/routes.dart';
import '../../shared/button.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import 'ba_component.dart';

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
          title: const Text("BERITA ACARA"),
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

  Future<void> _toSignMode() {
    return Future<void>.delayed(Duration.zero, () {
      _baProviderR.toSignMode().then((_) {
        showToastSuccess(
            context: context,
            message:
                "Dokumen berhasil dikirim, membutuhkan kelengkapan tanda tangan");
      }).onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  Future<void> _toSignScreen() {
    return Navigator.pushNamed(context, RouteGenerator.signature);
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
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: statusBasedview(data.baDetail))
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
          slivers.add(buildDescTable(detail.equipments, context));
          break;
        case "bullet":
          slivers.add(buildNumberedText(desc));
          break;
        default:
          slivers.add(buildDescParagraph(desc));
      }
    }
    slivers.add(buildPhotoList(detail.images, detail.completeStatus));
    slivers.add(buildDivider());
    slivers
        .add(buildDescParagraphBold(Description(0, "[ TANDA TANGAN ] :", "")));
    slivers.add(buildSignList(detail.participants, detail.completeStatus));
    slivers.add(buildDivider());
    slivers.add(buildDescParagraphBold(Description(0, "[ MENYETUJUI ] :", "")));
    slivers.add(buildSignList(detail.approvers, detail.completeStatus));
    slivers.add(buildDivider());

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

  Widget statusBasedview(BaDetailResponseData data) {
    bool _canSign = false;
    final String _userId = App.getID() ?? "";

    for (final Participant user in data.participants) {
      if (user.userID == _userId) {
        _canSign = true;
      }
    }

    for (final Participant user in data.approvers) {
      if (user.userID == _userId) {
        _canSign = true;
      }
    }

    if (data.completeStatus == 0) {
      return buildBottomDraft();
    } else if (data.completeStatus == 1 && _canSign) {
      return buildBottomSign();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildBottomDraft() {
    return Container(
      // height: 60,
      color: Colors.deepOrange.shade400.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.drafts,
              color: Colors.white,
            ),
            horizontalSpaceRegular,
            const Expanded(
              child: Text(
                "DRAFT\nHarap lengkapi dokumen sebelum ke proses selanjutnya",
                style: TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            ConfirmButton(
              iconData: Icons.send,
              text: "Kirim ",
              tapTap: _toSignMode,
              color: Colors.blue.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomSign() {
    return Container(
      // height: 60,
      color: Pallete.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            horizontalSpaceRegular,
            const Expanded(
              child: Text(
                "TANDA TANGAN\nPastikan semua sudah sesuai terlebih dahulu. Termasuk urutan penandatanganan.",
                style: TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
            ConfirmButton(
              iconData: CupertinoIcons.signature,
              text: "Sign ",
              tapTap: _toSignScreen,
              color: Colors.blue.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
