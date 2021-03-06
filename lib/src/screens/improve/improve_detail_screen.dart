import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/improve_list_resp.dart';
import '../../api/json_models/response/improve_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/improves.dart';
import '../../router/routes.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/increment_decrement_icon.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

GlobalKey<RefreshIndicatorState> refreshKeyImproveScreen =
    GlobalKey<RefreshIndicatorState>();

class ImproveDetailScreen extends StatefulWidget {
  @override
  _ImproveDetailScreenState createState() => _ImproveDetailScreenState();
}

class _ImproveDetailScreenState extends State<ImproveDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Improve Detail"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteGenerator.improveEdit);
            },
            icon: const Icon(
              CupertinoIcons.pencil_circle,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      body: ImproveRecyclerView(),
    );
  }
}

class ImproveRecyclerView extends StatefulWidget {
  @override
  _ImproveRecyclerViewState createState() => _ImproveRecyclerViewState();
}

class _ImproveRecyclerViewState extends State<ImproveRecyclerView> {
  Future<void> _loadDetailImprove() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<ImproveProvider>().getDetail().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  Future<void> _enablingImprove() {
    return Future<void>.delayed(Duration.zero, () {
      context.read<ImproveProvider>().enabling().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadDetailImprove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImproveProvider>(builder: (_, ImproveProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0, bottom: 0, left: 0, right: 0, child: buildListView(data)),
          if (data.detailState == ViewState.busy)
            const Center(child: CircularProgressIndicator())
        ],
      );
    });
  }

  Widget buildListView(ImproveProvider data) {
    final ImproveDetailResponseData detail = data.improveDetail;
    final ImproveMinResponse improveMinRess = ImproveMinResponse(
        detail.id,
        detail.createdAt,
        detail.updatedAt,
        detail.branch,
        detail.title,
        detail.description,
        detail.goal,
        detail.goalsAchieved,
        detail.isActive,
        detail.completeStatus);

    return RefreshIndicator(
      key: refreshKeyImproveScreen,
      onRefresh: _loadDetailImprove,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.improveEdit);
            },
            child: ImproveHeaderTile(
              data: detail,
            ),
          )),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              const Divider(
                color: Pallete.secondaryBackground,
                thickness: 5.0,
              ),
              if (detail.isActive)
                HomeLikeButton(
                    iconData: Icons.add,
                    text: "Tambah Progress",
                    tapTap: () {
                      data.setImproveDataPass(improveMinRess);
                      Navigator.pushNamed(
                          context, RouteGenerator.improveChange);
                    })
              else
                HomeLikeButton(
                    iconData: CupertinoIcons.rocket,
                    text: "Aktifkan",
                    tapTap: _enablingImprove),
              verticalSpaceSmall
            ],
          )),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChangeImproveTile(
                    dataTile: detail.improveChanges.reversed.toList()[index]),
              );
            }, childCount: detail.improveChanges.length),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 100,
          )),
        ],
      ),
    );
  }
}

class ImproveHeaderTile extends StatelessWidget {
  const ImproveHeaderTile({required this.data});
  final ImproveDetailResponseData data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shadowColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Pallete.secondaryBackground, width: 0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(data.title,
                  style: Theme.of(context).textTheme.bodyText1),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.description,
                  ),
                  Text("Target : ${data.goal}"),
                  Text("Tercapai : ${data.goalsAchieved}"),
                ],
              ),
              leading: (!data.isActive)
                  ? const Icon(Icons.disabled_by_default_rounded)
                  : null,
              trailing: (data.goal != 0)
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${(data.goalsAchieved / data.goal * 100).toInt()}%",
                        style: const TextStyle(fontSize: 10),
                      ))
                  : const SizedBox()),
        ),
      ),
    );
  }
}

class ChangeImproveTile extends StatelessWidget {
  const ChangeImproveTile({Key? key, required this.dataTile}) : super(key: key);
  final ImproveChange dataTile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: IncDecIcon(value: dataTile.increment),
          title: Text(dataTile.author.toLowerCase()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dataTile.time.getDateString(),
                style: const TextStyle(fontSize: 12),
              ),
              Text(dataTile.note),
            ],
          ),
        ),
      ),
    );
  }
}
