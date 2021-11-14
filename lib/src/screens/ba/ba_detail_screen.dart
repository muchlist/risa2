import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../../api/json_models/response/ba_resp.dart';

import '../../providers/ba_provider.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
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

    slivers.add(buildPhotoList(detail.images, detail.completeStatus));

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
}
