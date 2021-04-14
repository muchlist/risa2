import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/checks.dart';
import '../../router/routes.dart';
import '../../shared/check_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import 'add_check_dialog.dart';

var refreshKeyCheckSreen = GlobalKey<RefreshIndicatorState>();

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  late CheckProvider _checkProvider;

  @override
  void initState() {
    _checkProvider = context.read<CheckProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _checkProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Pengecekan shift"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteGenerator.checkMaster);
            },
            icon: Icon(
              CupertinoIcons.square_list,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      body: CheckRecyclerView(),
    );
  }
}

// CheckReceiclerView ------------------------------------
class CheckRecyclerView extends StatefulWidget {
  @override
  _CheckRecyclerViewState createState() => _CheckRecyclerViewState();
}

class _CheckRecyclerViewState extends State<CheckRecyclerView> {
  void _startAddCheck(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddCheckDialog(),
    );
  }

  Future<dynamic> _loadCheck() {
    return Future.delayed(Duration.zero, () {
      context.read<CheckProvider>().findCheck().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadCheck();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckProvider>(
      builder: (_, data, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (data.checkList.length != 0)
                    ? buildListView(data)
                    : (data.state == ViewState.idle)
                        ? EmptyBox(loadTap: _loadCheck)
                        : Center()),
            (data.state == ViewState.busy)
                ? Center(child: CircularProgressIndicator())
                : Center(),
            Positioned(
                bottom: 50,
                child: HomeLikeButton(
                    iconData: CupertinoIcons.add,
                    text: "Membuat Check ",
                    tapTap: () {
                      _startAddCheck(context);
                    })),
            Positioned(
              bottom: 50,
              right: 40,
              child: IconButton(
                  icon: const Icon(
                      CupertinoIcons.square_fill_line_vertical_square,
                      size: 28),
                  onPressed: () {}),
            )
          ],
        );
      },
    );
  }

  Widget buildListView(CheckProvider data) {
    return RefreshIndicator(
      key: refreshKeyCheckSreen,
      onRefresh: _loadCheck,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.checkList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                data.setCheckID(data.checkList[index].id);
                Navigator.of(context).pushNamed(RouteGenerator.checkDetail);
              },
              child: CheckListTile(data: data.checkList[index]));
        },
      ),
    );
  }
}
