import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../providers/computers.dart';
import '../../router/routes.dart';
import '../../shared/computer_item_widget.dart';
import '../../shared/empty_box.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';
import '../search/computer_search_delegate.dart';
import 'computer_with_incident_dialog.dart';

GlobalKey<RefreshIndicatorState> refreshKeyComputerScreen =
    GlobalKey<RefreshIndicatorState>();

class ComputerScreen extends StatefulWidget {
  @override
  _ComputerScreenState createState() => _ComputerScreenState();
}

class _ComputerScreenState extends State<ComputerScreen> {
  late ComputerProvider _computerProvider;

  @override
  void initState() {
    _computerProvider = context.read<ComputerProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _computerProvider.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Daftar Computer"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              CupertinoIcons.search,
              size: 28,
            ),
            onPressed: () async {
              // ignore: always_specify_types
              final searchResult = await showSearch(
                context: context,
                delegate: ComputerSearchDelegate(),
              );
              if (searchResult != null) {
                _computerProvider
                  ..removeDetail()
                  ..setComputerID(searchResult);
                await Navigator.pushNamed(
                    context, RouteGenerator.computerDetail);
              }
            },
          ),
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
            Navigator.pushNamed(context, RouteGenerator.computerAdd);
          },
          label: const Text("Tambah Komputer")),
      body: ComputerRecyclerView(),
    );
  }
}

class ComputerRecyclerView extends StatefulWidget {
  @override
  _ComputerRecyclerViewState createState() => _ComputerRecyclerViewState();
}

class _ComputerRecyclerViewState extends State<ComputerRecyclerView> {
  void _showComputerWithIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => ComputerWithIncidentDialog(),
    );
  }

  Future<void> _loadComputer() {
    return Future<void>.delayed(Duration.zero, () {
      context
          .read<ComputerProvider>()
          .findComputer()
          .onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  @override
  void initState() {
    _loadComputer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ComputerProvider>(builder: (_, ComputerProvider data, __) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: (data.computerList.isNotEmpty)
                  ? buildListView(data)
                  : (data.state == ViewState.idle)
                      ? EmptyBox(loadTap: _loadComputer)
                      : const Center()),
          if (data.state == ViewState.busy)
            const Center(child: CircularProgressIndicator())
          else
            const Center(),
        ],
      );
    });
  }

  Widget buildListView(ComputerProvider data) {
    return RefreshIndicator(
      key: refreshKeyComputerScreen,
      onRefresh: _loadComputer,
      child: CustomScrollView(
        slivers: <Widget>[
          if (data.computerExtraList.isNotEmpty)
            SliverToBoxAdapter(
                child: ComputerSliverHeading(
              totalIncident: data.computerExtraList.length,
              onTap: () => _showComputerWithIncident(context),
            )),
          // LIST CCTV INVENTORY
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    context.read<ComputerProvider>().removeDetail();
                    context
                        .read<ComputerProvider>()
                        .setComputerID(data.computerList[index].id);
                    Navigator.pushNamed(context, RouteGenerator.computerDetail);
                  },
                  child: ComputerListTile(data: data.computerList[index]));
            }, childCount: data.computerList.length),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 100,
          )),
        ],
      ),
    );
  }
}

class ComputerSliverHeading extends StatelessWidget {
  const ComputerSliverHeading(
      {required this.totalIncident, required this.onTap});
  final int totalIncident;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Pallete.secondaryBackground,
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Bermasalah: $totalIncident unit"),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: 16,
                backgroundColor: Colors.red.shade300,
                child: const Icon(
                  CupertinoIcons.eyeglasses,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
