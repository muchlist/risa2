import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:risa2/src/widgets/history_item.dart';
import 'corousel.dart';
import 'dashboard_grid.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 50,
                height: 50,
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
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                    text: "Welcome to RISA",
                    style: TextStyle(fontSize: 12, color: Colors.white))
              ]),
        ),
      ),
      // HOME BODY
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CorouselContainer(),
                DashboardGrid(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      HistoryItem(),
                      HistoryItem(),
                      HistoryItem(),
                    ],
                  ),
                )
              ],
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
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0)
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
                      Colors.white
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Membungkus Corousel dengan warna primary sehingga blend dengan AppBar
class CorouselContainer extends StatelessWidget {
  const CorouselContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // COROUSEL
        child: Corousel(),
      ),
    );
  }
}
