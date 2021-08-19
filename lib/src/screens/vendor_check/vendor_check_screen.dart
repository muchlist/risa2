import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/home_like_button.dart';
import 'add_vendor_check_dial.dart';
import 'altai_virtual_list_screen.dart';
import 'vendor_check_list_screen.dart';

class VendorCheckScreen extends StatefulWidget {
  @override
  _VendorCheckScreenState createState() => _VendorCheckScreenState();
}

class _VendorCheckScreenState extends State<VendorCheckScreen> {
  void _startAddVendorCheck(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddVendorCheckDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Check Virtual"),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                text: "CCTV",
              ),
              Tab(
                text: "ALTAI",
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: TabBarView(
                children: <Widget>[
                  VendorCheckRecyclerView(),
                  AltaiVirtualRecyclerView()
                ],
              ),
            ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: HomeLikeButton(
                      iconData: CupertinoIcons.add,
                      text: "Buat Checklist",
                      tapTap: () {
                        _startAddVendorCheck(context);
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
