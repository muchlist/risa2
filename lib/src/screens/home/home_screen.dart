import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'corousel_fragment.dart';
import 'dashboard_grid_fragment.dart';
import 'dashboard_history_fragment.dart';

final GlobalKey<ScaffoldState> scaffoldHomeKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startAddIncident(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              child: Center(
                child: Text("TEST"),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldHomeKey,
      // APPBAR -----------------------------------------------------------
      appBar: AppBar(
        actions: [
          const Icon(
            CupertinoIcons.search,
            size: 28,
          ),
          const SizedBox(
            width: 16,
          ),
          const Icon(
            CupertinoIcons.app_badge,
            size: 28,
          ),
          const SizedBox(
            width: 16,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 50,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      CupertinoIcons.person_circle,
                      size: 28,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        title: RichText(
          text: TextSpan(
              text: "Hi, Muchlis\n",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
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
                    height: 300,
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
                onPressed: () {}),
          )
        ],
      ),
    );
  }
}
