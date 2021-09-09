import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/response/server_config_resp.dart';
import '../../config/constant.dart';
import '../../providers/conf_server.dart';
import '../../shared/config_server_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class ServerConfigScreen extends StatefulWidget {
  @override
  _ServerConfigScreenState createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Config tersimpan"),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.decrease_indent,
              size: 28,
            ),
          ),
          horizontalSpaceSmall
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Navigator.pushNamed(context, RouteGenerator.serverConfigAdd);
          },
          label: const Text("Tambah data")),
      body: ServerConfigRecyclerView(),
    );
  }
}

class ServerConfigRecyclerView extends StatefulWidget {
  @override
  _ServerConfigRecyclerViewState createState() =>
      _ServerConfigRecyclerViewState();
}

class _ServerConfigRecyclerViewState extends State<ServerConfigRecyclerView> {
  final GlobalKey<RefreshIndicatorState> refreshKeyServerConfigScreen =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _loadServerConfig() {
    return Future<void>.delayed(Duration.zero, () {
      context
          .read<ServerConfigProvider>()
          .findServerConfig()
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadServerConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServerConfigProvider>(
        builder: (_, ServerConfigProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.serverConfigList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadServerConfig)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(ServerConfigProvider data) {
    return RefreshIndicator(
      key: refreshKeyServerConfigScreen,
      onRefresh: _loadServerConfig,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: data.serverConfigList.length,
        itemBuilder: (BuildContext context, int index) {
          final ServerConfigResponse dataSpec = data.serverConfigList[index];
          final ConfigListData dataToWidget = ConfigListData(
            title: dataSpec.title,
            note: dataSpec.note,
            diff: dataSpec.diff,
            imageUrl: "${Constant.baseUrl}${dataSpec.image.thumbnailMod()}",
            updatedAt: dataSpec.updatedAt,
            updatedBy: dataSpec.updatedBy,
          );

          return GestureDetector(
              onTap: () {
                context.read<ServerConfigProvider>().removeDetail();
                context
                    .read<ServerConfigProvider>()
                    .setServerConfigID(data.serverConfigList[index].id);
                // Navigator.pushNamed(
                //   context,
                //   RouteGenerator.serverConfigDetail,
                // );
              },
              child: ConfigListTile(data: dataToWidget));
        },
      ),
    );
  }
}
