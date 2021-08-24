import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vendor_check.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _nameController = TextEditingController();
  late final VendorCheckProvider _vendorMaintProvider;

  @override
  void initState() {
    _vendorMaintProvider = context.read<VendorCheckProvider>();
    Future<void>.delayed(
        Duration.zero, () => _vendorMaintProvider.resetSearchDetail());
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
                        _vendorMaintProvider.resetSearchDetail();
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
                _vendorMaintProvider.setSearchDetail(
                    search: _nameController.text);
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ));
  }
}
