import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/computer_edit_req.dart';
import '../../api/json_models/response/computer_resp.dart';
import '../../config/pallatte.dart';
import '../../providers/computers.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class EditComputerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Komputer"),
      ),
      body: EditComputerBody(),
    );
  }
}

class EditComputerBody extends StatefulWidget {
  @override
  _EditComputerBodyState createState() => _EditComputerBodyState();
}

class _EditComputerBodyState extends State<EditComputerBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isSeatManagement = false;
  String? _selectedLocation;
  String? _selectedDivision;
  String? _selectedOS;
  String? _selectedProcessor;
  int? _selectedRAM;
  int? _selectedHardisk;
  String? _selectedType;

  DateTime? _dateSelected;

  String getDateString() {
    if (_dateSelected == null) {
      return "Pilih tanggal";
    }
    return _dateSelected!.getMonthYearDisplay();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController hostnameController = TextEditingController();
  final TextEditingController inventoryNumController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _editComputer(int timestamp) {
    if (_key.currentState?.validate() ?? false) {
      // validasi tambahan
      String errorMessage = "";
      if (_selectedLocation == null) {
        errorMessage = errorMessage + "Lokasi tidak boleh kosong. ";
      }
      if (_selectedDivision == null) {
        errorMessage = errorMessage + "Divisi tidak boleh kosong. ";
      }
      if (_selectedType == null) {
        errorMessage = errorMessage + "Tipe tidak boleh kosong. ";
      }
      if (_selectedOS == null) {
        errorMessage = errorMessage + "OS tidak boleh kosong. ";
      }
      if (_selectedProcessor == null) {
        errorMessage = errorMessage + "Prosesor tidak boleh kosong. ";
      }

      if (errorMessage.isNotEmpty) {
        showToastWarning(context: context, message: errorMessage);
        return;
      }

      // Payload
      final ComputerEditRequest payload = ComputerEditRequest(
          filterTimestamp: timestamp,
          name: nameController.text,
          inventoryNumber: inventoryNumController.text,
          ip: ipController.text,
          location: _selectedLocation!,
          brand: brandController.text,
          date: (_dateSelected != null) ? _dateSelected!.toInt() : 0,
          tag: <String>[],
          note: noteController.text,
          type: _selectedType!,
          division: _selectedDivision!,
          hardisk: _selectedHardisk ?? 0,
          hostname: hostnameController.text,
          os: _selectedOS!,
          processor: _selectedProcessor!,
          ram: _selectedRAM ?? 0,
          seatManagement: _isSeatManagement);

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<ComputerProvider>()
                  .editComputer(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil mengubah computer ${payload.name}");
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
    inventoryNumController.dispose();
    ipController.dispose();
    brandController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    final ComputerDetailResponseData existData =
        context.read<ComputerProvider>().computerDetail;

    nameController.text = existData.name;
    hostnameController.text = existData.hostname;
    inventoryNumController.text = existData.inventoryNumber;
    ipController.text = existData.ip;
    brandController.text = existData.brand;
    noteController.text = existData.note;
    if (existData.date != 0) {
      _dateSelected = existData.date.toDate();
    }
    _isSeatManagement = existData.seatManagement;

    // default length == 1 , if option got update length more than 1
    if (context.read<ComputerProvider>().computerOption.type.length == 1) {
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<ComputerProvider>()
                  .findOptionComputer()
                  .onError((Object? error, _) {
                showToastError(context: context, message: error.toString());
              })).whenComplete(() {
        _selectedLocation = existData.location;
        _selectedDivision = existData.division;
        _selectedType = existData.type;
        _selectedOS = existData.os;
        _selectedProcessor = existData.processor;
        _selectedRAM = existData.ram;
        _selectedHardisk = existData.hardisk;
      });
    } else {
      _selectedLocation = existData.location;
      _selectedDivision = existData.division;
      _selectedType = existData.type;
      _selectedOS = existData.os;
      _selectedProcessor = existData.processor;
      _selectedRAM = existData.ram;
      _selectedHardisk = existData.hardisk;
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
                  "Nama User",
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
                      return 'Nama user tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                verticalSpaceSmall,

                // * Host Name text ------------------------
                const Text(
                  "Hostname",
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
                  controller: hostnameController,
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

                // * IP Editress text
                const Text(
                  "IP Editress",
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
                        return "IP Editress tidak valid";
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
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
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
                        items: data.computerOption.location.map((String loc) {
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
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
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
                        items: data.computerOption.division.map((String loc) {
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

                // * Seat switch
                Row(children: <Widget>[
                  horizontalSpaceTiny,
                  const Text("Komputer sewa? "),
                  const Spacer(),
                  Switch(
                    value: _isSeatManagement,
                    onChanged: (bool value) {
                      setState(() {
                        _isSeatManagement = !_isSeatManagement;
                      });
                    },
                    activeTrackColor: Pallete.secondaryBackground,
                    activeColor: Pallete.green,
                  ),
                ]),
                verticalSpaceSmall,

                // * Type dropdown ------------------------
                const Text(
                  "Tipe Computer",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Tipe"),
                        value: (_selectedType != null) ? _selectedType : null,
                        items: data.computerOption.type.map((String loc) {
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

                // * OS dropdown ------------------------
                const Text(
                  "Sistem Operasi",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Sistem Operasi"),
                        value: (_selectedOS != null) ? _selectedOS : null,
                        items: data.computerOption.os.map((String loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedOS = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

                verticalSpaceSmall,

                // * Prosesor dropdown ------------------------
                const Text(
                  "Prosesor",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Prosesor"),
                        value: (_selectedProcessor != null)
                            ? _selectedProcessor
                            : null,
                        items: data.computerOption.processor.map((String loc) {
                          return DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedProcessor = value;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

                verticalSpaceSmall,

                // * RAM dropdown ------------------------
                const Text(
                  "RAM",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("RAM"),
                        value: (_selectedRAM != null)
                            ? _selectedRAM.toString()
                            : null,
                        items: data.computerOption.ram.map((int loc) {
                          return DropdownMenuItem<String>(
                            value: loc.toString(),
                            child: Text(loc.toString()),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedRAM = int.tryParse(value ?? "0");
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                      ),
                    ),
                  );
                }),

                verticalSpaceSmall,

                // * Hardisk dropdown ------------------------
                const Text(
                  "Hardisk",
                  style: TextStyle(fontSize: 16),
                ),
                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Hardisk"),
                        value: (_selectedHardisk != null)
                            ? _selectedHardisk.toString()
                            : null,
                        items: data.computerOption.hardisk.map((int loc) {
                          return DropdownMenuItem<String>(
                            value: loc.toString(),
                            child: Text(loc.toString()),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedHardisk = int.tryParse(value ?? "0");
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
                      fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: noteController,
                ),

                verticalSpaceMedium,

                Consumer<ComputerProvider>(
                    builder: (_, ComputerProvider data, __) {
                  return (data.state == ViewState.busy)
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: HomeLikeButton(
                              iconData: CupertinoIcons.pencil_circle,
                              text: "Edit Komputer",
                              tapTap: () =>
                                  _editComputer(data.computerDetail.updatedAt)),
                        );
                }),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
