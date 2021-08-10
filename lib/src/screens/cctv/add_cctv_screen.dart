import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/cctv_req.dart';
import '../../config/pallatte.dart';
import '../../providers/cctvs.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class AddCctvScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Tambah Cctv"),
      ),
      body: AddCctvBody(),
    );
  }
}

class AddCctvBody extends StatefulWidget {
  @override
  _AddCctvBodyState createState() => _AddCctvBodyState();
}

class _AddCctvBodyState extends State<AddCctvBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _selectedLocation;
  String? _selectedType;

  DateTime? _dateSelected;

  String getDateString() {
    if (_dateSelected == null) {
      return "Pilih tanggal";
    }
    return _dateSelected!.getMonthYearDisplay();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController inventoryNumController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _addCctv() {
    if (_key.currentState?.validate() ?? false) {
      // validasi tambahan
      String errorMessage = "";
      if (_selectedLocation == null) {
        errorMessage = errorMessage + "lokasi tidak boleh kosong. ";
      }
      if (_selectedType == null) {
        errorMessage = errorMessage + "tipe tidak boleh kosong. ";
      }

      if (errorMessage.isNotEmpty) {
        showToastWarning(context: context, message: errorMessage);
        return;
      }

      // Payload
      final CctvRequest payload = CctvRequest(
          name: nameController.text,
          inventoryNumber: inventoryNumController.text,
          ip: ipController.text,
          location: _selectedLocation!,
          brand: brandController.text,
          date: (_dateSelected != null) ? _dateSelected!.toInt() : 0,
          tag: <String>[],
          note: noteController.text,
          type: _selectedType!);

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () =>
              context.read<CctvProvider>().addCctv(payload).then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil membuat cctv ${payload.name}");
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
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    inventoryNumController.dispose();
    ipController.dispose();
    brandController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // default length == 1 , if option got update length more than 1
    if (context.read<CctvProvider>().cctvOption.location.length == 1) {
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<CctvProvider>()
                  .findOptionCctv()
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
                  "Nama Cctv",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: nameController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Nama cctv tidak boleh kosong';
                    }
                    return null;
                  },
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
                      fillColor: Pallete.secondaryBackground,
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
                      fillColor: Pallete.secondaryBackground,
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
                Consumer<CctvProvider>(builder: (_, CctvProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(color: Pallete.secondaryBackground),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Lokasi"),
                        value: (_selectedLocation != null)
                            ? _selectedLocation
                            : null,
                        items: data.cctvOption.location.map((String loc) {
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
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: brandController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return "merk tidak boleh kosong";
                    }
                    return null;
                  },
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
                    decoration:
                        const BoxDecoration(color: Pallete.secondaryBackground),
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

                // * Type dropdown ------------------------
                const Text(
                  "Tipe Cctv",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<CctvProvider>(builder: (_, CctvProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(color: Pallete.secondaryBackground),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Tipe"),
                        value: (_selectedType != null) ? _selectedType : null,
                        items: data.cctvOption.type.map((String loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedType = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

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
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: noteController,
                ),

                verticalSpaceMedium,

                Consumer<CctvProvider>(builder: (_, CctvProvider data, __) {
                  return (data.state == ViewState.busy)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.add,
                              text: "Tambah Cctv",
                              tapTap: _addCctv),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
