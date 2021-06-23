import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/utils/enums.dart';

import '../../providers/dashboard.dart';
import '../../shared/chart_speed.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.restart,
              size: 28,
            ),
            onPressed: () {},
          ),
          horizontalSpaceSmall
        ],
      ),
      body: DashboardBody(),
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({Key? key}) : super(key: key);

  @override
  _DashboardBodyState createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  Future<dynamic> _loadSpeedTestData() {
    return Future.delayed(Duration.zero, () {
      context
          .read<DashboardProvider>()
          .retrieveSpeed()
          .then((_) {})
          .onError((error, _) {
        if (error != null) {
          showToastError(context: context, message: error.toString());
        }
      });
    });
  }

  @override
  void initState() {
    _loadSpeedTestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<DashboardProvider>(builder: (_, data, __) {
              if (data.state == ViewState.busy) {
                return const Center(child: CircularProgressIndicator());
              }
              return LineChartSpeedTest(data: data.lastTeenSpeedList);
            }),
          ),
        ],
      ),
    );
  }
}
