import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/providers/checks.dart';
import 'package:risa2/src/providers/checks_master.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:risa2/src/shared/empty_box.dart';
import 'package:risa2/src/shared/flushbar.dart';
import 'package:risa2/src/shared/home_like_button.dart';
import 'package:risa2/src/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/utils/enums.dart';

var refreshKeyCheckMasterSreen = GlobalKey<RefreshIndicatorState>();

class CheckMasterScreen extends StatefulWidget {
  @override
  _CheckMasterScreenState createState() => _CheckMasterScreenState();
}

class _CheckMasterScreenState extends State<CheckMasterScreen> {
  late CheckMasterProvider _checkMasterProvider;

  @override
  void initState() {
    _checkMasterProvider = context.read<CheckMasterProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _checkMasterProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Master pengecekan"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.square_list,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      body: CheckMasterRecyclerView(),
    );
  }
}

// CheckMasterReceiclerView ------------------------------------
class CheckMasterRecyclerView extends StatefulWidget {
  @override
  _CheckMasterRecyclerViewState createState() =>
      _CheckMasterRecyclerViewState();
}

class _CheckMasterRecyclerViewState extends State<CheckMasterRecyclerView> {
  // void _startAddCheck(BuildContext context) {
  //   showModalBottomSheet(
  //     // isScrollControlled: true,
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20), topRight: Radius.circular(20)),
  //     ),
  //     builder: (context) => AddCheckDialog(),
  //   );
  // }

  Future<dynamic> _loadCheck() {
    return Future.delayed(Duration.zero, () {
      context.read<CheckMasterProvider>().findCheckMaster().onError((error, _) {
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
    return Consumer<CheckMasterProvider>(
      builder: (_, data, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: (data.checkpList.length != 0)
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
                      // _startAddCheck(context);
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

  Widget buildListView(CheckMasterProvider data) {
    return RefreshIndicator(
      key: refreshKeyCheckMasterSreen,
      onRefresh: _loadCheck,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: data.checkpList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                data.setCheckID(data.checkpList[index].id);
                // Navigator.of(context).pushNamed(RouteGenerator.checkDetail); // todo
              },
              child: ListTile(
                title: Text(data.checkpList[index].name),
              ));
        },
      ),
    );
  }
}