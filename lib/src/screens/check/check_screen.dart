import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/services/check_service.dart';
import 'package:risa2/src/providers/checks.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/screens/check/add_check_dialog.dart';
import 'package:risa2/src/widgets/check_item_widget.dart';
import 'package:risa2/src/widgets/home_like_button.dart';

class CheckScreen extends StatelessWidget {
  final checkService = CheckService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckProvider>(
      create: (_) => CheckProvider(checkService),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Checklist"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.square_list,
                size: 28,
              ),
            ),
            SizedBox(
              width: 8,
            )
          ],
        ),
        body: CheckRecyclerView(),
      ),
    );
  }
}

// CheckReceiclerView ------------------------------------
class CheckRecyclerView extends StatefulWidget {
  @override
  _CheckRecyclerViewState createState() => _CheckRecyclerViewState();
}

class _CheckRecyclerViewState extends State<CheckRecyclerView> {
  bool _isloading = false;
  void setLoading(bool loading) {
    setState(() {
      _isloading = loading;
    });
  }

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

  @override
  void initState() {
    setLoading(true);
    context.read<CheckProvider>().findCheck().then((_) {
      setLoading(false);
    }).onError((error, _) {
      Flushbar(
        message: error.toString(),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red.withOpacity(0.7),
      )..show(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Consumer<CheckProvider>(builder: (_, data, __) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 60),
              itemCount: data.checkList.length,
              itemBuilder: (context, index) {
                return CheckListTile(data: data.checkList[index]);
              },
            );
          }),
        ),
        (_isloading) ? CircularProgressIndicator() : Center(),
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
              icon: const Icon(CupertinoIcons.square_fill_line_vertical_square,
                  size: 28),
              onPressed: () {}),
        )
      ],
    );
  }
}
