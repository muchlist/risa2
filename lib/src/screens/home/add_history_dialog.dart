import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/filter_models/general_filter.dart';
import 'package:risa2/src/api/json_models/response/general_list_resp.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/providers/generals.dart';
import 'package:risa2/src/screens/search/general_search_delegate.dart';
import 'package:provider/provider.dart';

class ItemChoice {
  final int id;
  final String label;

  ItemChoice(this.id, this.label);
}

class AddHistoryDialog extends StatefulWidget {
  const AddHistoryDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddHistoryDialogState createState() => _AddHistoryDialogState();
}

class _AddHistoryDialogState extends State<AddHistoryDialog> {
  final listChoices = <ItemChoice>[
    ItemChoice(1, 'CCTV'),
    ItemChoice(2, 'PC'),
  ];
  var _categoryIDSelected = 0;
  var _selectedUnitID = "";
  var _selectedUnit = "Pilih Perangkat";
  var _selectedStatus = "Pilih Progress";

  // final usernameController = TextEditingController();
  // final passwordController = TextEditingController();

  var _isLoading = false;

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    // usernameController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  // void _addHistory() {
  //   if (_key.currentState?.validate() ?? false) {
  //     setLoading(true);

  //     final username = usernameController.text;
  //     final password = passwordController.text;

  //     authViewModel.login(username, password).then((value) {
  //       setLoading(false);
  //       if (value) {
  //         Navigator.of(context).pushNamedAndRemoveUntil(
  //             RouteGenerator.home, ModalRoute.withName(RouteGenerator.home));
  //       }
  //     }).onError((error, _) {
  //       setLoading(false);
  //       if (error != null) {
  //         final snackBar = SnackBar(
  //           content: Text(error.toString()),
  //           duration: Duration(seconds: 3),
  //         );
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       }
  //     });
  //   } else {
  //     debugPrint("Error :(");
  //   }
  // }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              indent: 70,
              endIndent: 70,
              height: 10,
              thickness: 5,
              color: Pallete.secondaryBackground,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * Pilih kategori text ------------------------
                    const Text(
                      "Kategori :",
                      style: TextStyle(fontSize: 16),
                    ),
                    // * Chip choice
                    Wrap(
                      children: listChoices
                          .map((e) => ChoiceChip(
                                label: Text(
                                  e.label,
                                  style: (_categoryIDSelected == e.id)
                                      ? TextStyle(color: Colors.white)
                                      : TextStyle(),
                                ),
                                selected: _categoryIDSelected == e.id,
                                selectedColor: Theme.of(context).accentColor,
                                // * Setstate ------------------------------
                                onSelected: (_) => setState(() {
                                  _categoryIDSelected = e.id;
                                  context.read<GeneralProvider>().setFilter(
                                      FilterGeneral(category: e.label));
                                  context
                                      .read<GeneralProvider>()
                                      .findGeneral("");
                                }),
                              ))
                          .toList(),
                      spacing: 5,
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // * Pilih perangkat text ------------------------
                    const Text(
                      "Perangkat / Software :",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_categoryIDSelected == 0) {
                          setState(() {
                            _selectedUnit =
                                "Harap memilih kategori terlebih dahulu";
                          });
                          return;
                        }
                        final searchResult =
                            await showSearch<GeneralMinResponse?>(
                          context: context,
                          delegate: GeneralSearchDelegate(),
                        );
                        if (searchResult != null) {
                          setState(() {
                            _selectedUnit = searchResult.name;
                            _selectedUnitID = searchResult.id;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(color: Pallete.secondaryBackground),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedUnit,
                              ),
                              Icon(CupertinoIcons.search),
                            ]),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // * Problem text ------------------------
                    const Text(
                      "Problem",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'username tidak boleh kosong';
                        }
                        return null;
                      },
                      // controller: usernameController,
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // * Status pekerjaan text ------------------------
                    const Text(
                      "Status pekerjaan",
                      style: TextStyle(fontSize: 16),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration:
                          BoxDecoration(color: Pallete.secondaryBackground),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Pilih progress"),
                          items: <String>[
                            'Progress',
                            'Pending',
                            'Complete',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // * ResolveNote text ------------------------
                    const Text(
                      "Resolve Note",
                      style: TextStyle(fontSize: 16),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.newline, maxLines: 3,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Pallete.secondaryBackground,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'username tidak boleh kosong';
                        }
                        return null;
                      },
                      // controller: usernameController,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // * Button ---------------------------
                    GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(24)),
                          child: const Text.rich(TextSpan(children: [
                            WidgetSpan(
                                child: Icon(
                              CupertinoIcons.add,
                              size: 15,
                              color: Colors.white,
                            )),
                            TextSpan(
                                text: "Tambah Log",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))
                          ])),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
