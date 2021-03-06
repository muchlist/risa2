import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/other_req.dart';
import '../../providers/others.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class AddOtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Tambah ${context.read<OtherProvider>().subCategory}"),
      ),
      body: AddOtherBody(),
    );
  }
}

class AddOtherBody extends StatefulWidget {
  @override
  _AddOtherBodyState createState() => _AddOtherBodyState();
}

class _AddOtherBodyState extends State<AddOtherBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _selectedLocation;
  String? _selectedDivision;
  DateTime? _dateSelected;

  String getDateString() {
    if (_dateSelected == null) {
      return "Pilih tanggal";
    }
    return _dateSelected!.getMonthYearDisplay();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController inventoryNumController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController tipeController = TextEditingController();

  void _addOther() {
    if (_key.currentState?.validate() ?? false) {
      // validasi tambahan
      String errorMessage = "";
      if (_selectedLocation == null) {
        errorMessage = errorMessage + "Lokasi tidak boleh kosong. ";
      }

      if (errorMessage.isNotEmpty) {
        showToastWarning(context: context, message: errorMessage);
        return;
      }

      // Payload
      final OtherRequest payload = OtherRequest(
        subCategory: context.read<OtherProvider>().subCategory,
        name: nameController.text,
        detail: detailController.text,
        inventoryNumber: inventoryNumController.text,
        ip: ipController.text,
        location: _selectedLocation ?? "",
        brand: brandController.text,
        date: (_dateSelected != null) ? _dateSelected!.toInt() : 0,
        tag: <String>[],
        note: noteController.text,
        type: tipeController.text,
        division: _selectedDivision ?? "",
      );

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<OtherProvider>()
                  .addOther(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil membuat ${payload.name}");
                }
              }).onError((Object? error, _) {
                if (error != null) {
                  showToastError(context: context, message: error.toString());
                }
              }));
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime initialDate =
        (_dateSelected == null) ? DateTime.now() : _dateSelected!;
    final DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime(DateTime.now().year + 1));

    if (newDate == null) {
      return;
    }
    setState(() {
      _dateSelected = newDate;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    detailController.dispose();
    inventoryNumController.dispose();
    ipController.dispose();
    brandController.dispose();
    noteController.dispose();
    tipeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // default length == 1 , if option got update length more than 1
    if (context.read<OtherProvider>().otherOption.location.length == 1) {
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<OtherProvider>()
                  .findOptionOther()
                  .onError((Object? error, _) {
                showToastError(context: context, message: error.toString());
              }));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Consumer ------------------------------------------------------
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // * Judul text ------------------------
                const Text(
                  "Nama item",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: nameController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Nama item tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                verticalSpaceSmall,

                // * detail text ------------------------
                const Text(
                  "Detail",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: detailController,
                ),

                verticalSpaceSmall,

                // * Nomer Inventaris text ------------------------
                const Text(
                  "Nomer Inventaris",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: inventoryNumController,
                ),

                verticalSpaceSmall,

                // * IP Address text
                const Text(
                  "IP Address",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: ipController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return null;
                    } else {
                      if (!ValueValidator().ip(text)) {
                        return "IP Address tidak valid";
                      }
                    }
                    return null;
                  },
                ),

                verticalSpaceSmall,

                // * Lokasi dropdown ------------------------
                const Text(
                  "Lokasi",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<OtherProvider>(builder: (_, OtherProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Lokasi"),
                        value: (_selectedLocation != null)
                            ? _selectedLocation
                            : null,
                        items: data.otherOption.location.map((String loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLocation = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

                verticalSpaceSmall,

                // * Divisi dropdown ------------------------
                const Text(
                  "Divisi",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<OtherProvider>(builder: (_, OtherProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Divisi"),
                        value: (_selectedDivision != null)
                            ? _selectedDivision
                            : null,
                        items: data.otherOption.division.map((String loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDivision = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

                verticalSpaceSmall,

                // * Brand text ------------------------
                const Text(
                  "Merk",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: brandController,
                ),

                verticalSpaceSmall,

                // * Satuan text ------------------------
                const Text(
                  "Date",
                  style: TextStyle(fontSize: 16),
                ),

                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            getDateString(),
                          ),
                          const Icon(CupertinoIcons.calendar),
                        ]),
                  ),
                ),

                verticalSpaceSmall,

                // * Brand text ------------------------
                const Text(
                  "Tipe",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: tipeController,
                ),

                verticalSpaceSmall,

                // * Note text ------------------------
                const Text(
                  "Catatan",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: noteController,
                ),

                verticalSpaceMedium,

                Consumer<OtherProvider>(builder: (_, OtherProvider data, __) {
                  return (data.state == ViewState.busy)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text:
                                  "Tambah ${context.read<OtherProvider>().subCategory}",
                              tapTap: _addOther),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
