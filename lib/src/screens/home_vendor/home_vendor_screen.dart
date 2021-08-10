import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/utils/enums.dart';

import '../../api/filter_models/history_filter.dart';
import '../../config/histo_category.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../models/dashboard.dart';
import '../../providers/auth.dart';
import '../../providers/histories.dart';
import '../../router/routes.dart';
import '../../shared/dashboard_v_item_widget.dart';
import '../../shared/disable_glow.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/history_v_item_complete.dart';
import '../../shared/history_v_item_widget.dart';
import '../../shared/ui_helpers.dart';

class HomeVScreen extends StatefulWidget {
  @override
  _HomeVScreenState createState() => _HomeVScreenState();
}

class _HomeVScreenState extends State<HomeVScreen> {
  var refreshKeyHome = GlobalKey<RefreshIndicatorState>();
  late HistoryProvider historyProvider;
  late FirebaseMessaging messaging;

  Future<dynamic> _loadHistory() {
    return Future.delayed(Duration.zero, () {
      historyProvider.setFilter(FilterHistory(
          branch: App.getBranch(),
          category: "${HistCategory.cctv},${HistCategory.altai}"));

      historyProvider.findHistory().then((_) {}).onError((error, _) {
        if (error != null) {
          showToastError(context: context, message: error.toString());
        }
      });
    });
  }

  Future<bool?> _logoutConfirm(BuildContext context) {
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi logout"),
            content: const Text(
                "Apakah anda yakin ingin ingin logout? salah pencet? maaf karena kami meletakkan tombol logout didekat tombol pencarian."),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor),
                  child: const Text("Jangan Logout"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Logout"))
            ],
          );
        });
  }

  @override
  void initState() {
    historyProvider = context.read<HistoryProvider>();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) async {
      final firebaseTokenSaved = App.getFireToken();
      if (value != firebaseTokenSaved) {
        if (value != null) {
          final success =
              await context.read<AuthProvider>().sendFCMToken(value);
          if (success) {
            await App.setFireToken(value);
          }
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showToastWarning(
            context: context,
            message: message.notification?.body ?? "",
            onTop: true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _loadHistory();
    });

    _loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // APPBAR -----------------------------------------------------------
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                CupertinoIcons.square_arrow_right,
                size: 28,
              ),
              onPressed: () async {
                final logout = await _logoutConfirm(context);
                if (logout != null && logout) {
                  await App.setToken("");
                  await Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.login, (route) => false);
                }
              }),
          horizontalSpaceSmall,
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
              text: "Hi ${App.getName() ?? "User"}\n",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                const TextSpan(
                    text: "Welcome to RISA",
                    style: TextStyle(fontSize: 12, color: Colors.black))
              ]),
        ),
      ),

      // BODY ------------------------------------------------------------
      body: Consumer<HistoryProvider>(
        builder: (_, data, __) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // BODY INSIDE
              Positioned(
                bottom: 0,
                top: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _loadHistory();
                    },
                    key: refreshKeyHome,
                    child: DisableOverScrollGlow(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          buildSliverAppBar(),
                          SliverToBoxAdapter(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SELESAI DIPERBAIKI",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                          buildSliverHistoryCompleted(data),
                          if (data.historyProgressList.length != 0)
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "CCTV BERMASALAH",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )),
                          buildStaggeredHistory(data),
                          SliverPadding(padding: EdgeInsets.only(bottom: 100))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0),
                          Theme.of(context).scaffoldBackgroundColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 30,
                  child: GestureDetector(
                    onTap: () {
                      HistoryHelper().showAddIncidentV(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text.rich(TextSpan(children: [
                        WidgetSpan(
                            child: Icon(
                          CupertinoIcons.add,
                          size: 21,
                          color: Colors.white,
                        )),
                        TextSpan(
                            text: "Tambah Log",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))
                      ])),
                    ),
                  )),
              Positioned(
                bottom: 30,
                right: 40,
                child: IconButton(
                    icon: const Icon(CupertinoIcons.circle_grid_3x3_fill,
                        size: 28),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteGenerator.history);
                    }),
              ),
              Positioned(
                bottom: 30,
                left: 40,
                child: IconButton(
                    icon:
                        const Icon(CupertinoIcons.square_arrow_down, size: 28),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteGenerator.pdf);
                    }),
              ),
              if (data.state == ViewState.busy)
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(child: CircularProgressIndicator()))
            ],
          );
        },
      ),
    );
  }

  SliverList buildSliverHistoryCompleted(HistoryProvider data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          {
            return GestureDetector(
              onDoubleTap: () => HistoryHelper().showEditIncident(
                  context, data.historyCompletedList[index], false),
              onTap: () => HistoryHelper().showDetailIncident(
                  context, data.historyCompletedList[index]),
              onLongPress: () => HistoryHelper().showParent(
                  context: context,
                  category: data.historyCompletedList[index].category,
                  parentID: data.historyCompletedList[index].parentID),
              child: HistoryVCListTile(
                history: data.historyCompletedList[index],
              ),
            );
          }
        },
        childCount: (data.historyCompletedList.length >= 2)
            ? 2
            : data.historyCompletedList.length,
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      toolbarHeight: 90,
      // snap: true,
      // floating: true,
      flexibleSpace: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteGenerator.history),
            child: DashboardVIcon(
              Dashboard("History", CupertinoIcons.circle_grid_3x3_fill,
                  color: Pallete.green),
            ),
          ),
          horizontalSpaceTiny,
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteGenerator.cctv),
            child: DashboardVIcon(Dashboard("CCTV", CupertinoIcons.camera,
                color: Pallete.green.withOpacity(0.8))),
          ),
          horizontalSpaceTiny,
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, RouteGenerator.vendorCheck),
            child: DashboardVIcon(Dashboard(
                "Cek CCTV", CupertinoIcons.checkmark_seal,
                color: Pallete.green.withOpacity(0.6))),
          ),
        ],
      ),
    );
  }

  Widget buildStaggeredHistory(HistoryProvider data) {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 2,
      itemCount: data.historyProgressList.length,
      staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
      itemBuilder: (BuildContext ctx, int index) {
        return GestureDetector(
          onDoubleTap: () => HistoryHelper().showEditIncident(
              context, data.historyProgressList[index], false),
          onTap: () => HistoryHelper()
              .showDetailIncident(context, data.historyProgressList[index]),
          onLongPress: () => HistoryHelper().showParent(
              context: context,
              category: data.historyProgressList[index].category,
              parentID: data.historyProgressList[index].parentID),
          child: HistoryVListTile(
            history: data.historyProgressList[index],
          ),
        );
      },
    );
  }
}
