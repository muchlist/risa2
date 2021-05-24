import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/router/routes.dart';

import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/generals.dart';
import '../../shared/ui_helpers.dart';
import '../search/main_search_delegate.dart';
import 'add_history_dialog.dart';
import 'corousel_fragment.dart';
import 'dashboard_grid_fragment.dart';
import 'dashboard_history_fragment.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // * ADD INCIDENT (add_history_dialog)
  void _startAddIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddHistoryDialog(),
    );
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
              showSearch(
                context: context,
                delegate: MainSearchDelegate(),
              );
            },
          ),
          horizontalSpaceSmall,
          const Icon(
            CupertinoIcons.app_badge,
            size: 28,
          ),
          horizontalSpaceSmall,
          IconButton(
              icon: Icon(
                CupertinoIcons.person_solid,
                size: 28,
              ),
              onPressed: () {}),
          horizontalSpaceSmall,
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
              text: "Hi ${App.getName() ?? "Manusia"}\n",
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
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CorouselContainer(),
                  DashboardGrid(),
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
                  _startAddIncident(context);
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
          )
        ],
      ),
    );
  }
}
