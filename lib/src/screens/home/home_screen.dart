import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/filter_models/general_filter.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/auth.dart';
import '../../providers/generals.dart';
import '../../providers/histories.dart';
import '../../providers/improves.dart';
import '../../router/routes.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/func_history_dialog.dart';
import '../../shared/ui_helpers.dart';
import '../search/main_search_delegate.dart';
import 'corousel_fragment.dart';
import 'dashboard_grid_fragment.dart';
import 'dashboard_history_fragment.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var refreshKeyHome = GlobalKey<RefreshIndicatorState>();
  late FirebaseMessaging messaging;

  Future<dynamic> _loadHistory() {
    return Future.delayed(Duration.zero, () {
      context
          .read<HistoryProvider>()
          .findHistory()
          .then((_) {})
          .onError((error, _) {
        if (error != null) {
          showToastError(context: context, message: error.toString());
        }
      });
    });
  }

  Future<dynamic> _loadImprove() {
    return Future.delayed(Duration.zero, () {
      context.read<ImproveProvider>().findImprove();
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
      // notifikasi di klik
    });

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
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () {
              context.read<GeneralProvider>().removeGenerals();
              context.read<GeneralProvider>().setFilter(FilterGeneral());
              showSearch(
                context: context,
                delegate: MainSearchDelegate(),
              );
            },
          ),
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
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            top: 0,
            right: 0,
            left: 0,
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadHistory();
                await _loadImprove();
              },
              key: refreshKeyHome,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CorouselContainer(),
                    DashboardGrid(),
                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DashboardListView(),
                    ),
                    const SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Center(
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Pallete.background,
                      Pallete.background.withOpacity(0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
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
              bottom: 50,
              child: GestureDetector(
                onTap: () {
                  HistoryHelper().showAddIncident(context);
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
            bottom: 50,
            right: 40,
            child: IconButton(
                icon: const Icon(CupertinoIcons.circle_grid_3x3_fill, size: 28),
                onPressed: () {
                  Navigator.pushNamed(context, RouteGenerator.history);
                }),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: IconButton(
                icon: const Icon(CupertinoIcons.square_arrow_down, size: 28),
                onPressed: () {
                  Navigator.pushNamed(context, RouteGenerator.pdf);
                }),
          )
        ],
      ),
    );
  }
}
