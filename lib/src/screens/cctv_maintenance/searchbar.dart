import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cctv_maintenance.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _nameController = TextEditingController();
  late final CctvMaintProvider _cctvMaintProvider;

  @override
  void initState() {
    _cctvMaintProvider = context.read<CctvMaintProvider>();
    Future<void>.delayed(
        Duration.zero, () => _cctvMaintProvider.resetSearchDetail());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                minLines: 1,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _cctvMaintProvider.resetSearchDetail();
                        _nameController.clear();
                        FocusScope.of(context).requestFocus(
                          FocusNode(),
                        );
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: InputBorder.none),
                onFieldSubmitted: (String text) => () {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: () {
                _cctvMaintProvider.setSearchDetail(
                    search: _nameController.text);
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ));
  }
}
