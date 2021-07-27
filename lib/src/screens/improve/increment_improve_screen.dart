import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/improve_change_req.dart';
import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/improves.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class IncrementImproveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Update Progress"),
      ),
      body: IncrementImproveBody(),
    );
  }
}

class IncrementImproveBody extends StatefulWidget {
  @override
  _IncrementImproveBodyState createState() => _IncrementImproveBodyState();
}

class _IncrementImproveBodyState extends State<IncrementImproveBody> {
  late final ImproveProvider _improveProvider;
  late bool _approver;

  final _key = GlobalKey<FormState>();
  final noteController = TextEditingController();

  late double _selectedSlider;
  double _numberChange = 0.0;

  String _statusIncrement() {
    if (_numberChange >= 0) {
      return "( perubahan +${_numberChange.toInt()} )";
    } else {
      return "( perubahan ${_numberChange.toInt()} )";
    }
  }

  Future<void> _enablingImprove() {
    return Future.delayed(Duration.zero, () {
      _improveProvider.enabling().onError((error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  void _incrementImprove() {
    if (_key.currentState?.validate() ?? false) {
      final timeNow = DateTime.now().toInt();
      // Payload
      final payload = ImproveChangeRequest(
          increment: _numberChange.toInt(),
          note: noteController.text,
          time: timeNow);

      // Call Provider
      Future.delayed(
          Duration.zero,
          () => _improveProvider
                  .incrementImprovement(
                      _improveProvider.improveDataPass?.id ?? "", payload)
                  .then((value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil mengupdate improvement");
                }
              }).onError((error, _) {
                if (error != null) {
                  showToastError(
                      context: context, message: error.toString(), onTop: true);
                }
              }));
    }
  }

  @override
  void initState() {
    _improveProvider = context.read<ImproveProvider>();
    _selectedSlider =
        _improveProvider.improveDataPass?.goalsAchieved.toDouble() ?? 0.0;
    _approver = App.getRoles().any((element) {
      return element == "APPROVE";
    });
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataPass = _improveProvider.improveDataPass!;

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Consumer ------------------------------------------------------
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * Judul text ------------------------
                const Text(
                  "Judul",
                  style: TextStyle(fontSize: 16),
                ),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dataPass.title),
                  ),
                ),

                verticalSpaceSmall,

                // * Judul text ------------------------
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 16),
                ),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dataPass.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                verticalSpaceSmall,

                // * Status pekerjaan text ------------------------
                if (dataPass.goal != 0)
                  Text(
                    "Progress ${(dataPass.goalsAchieved / dataPass.goal * 100).toInt().toString()}%  menjadi  ${(_selectedSlider / dataPass.goal * 100).toInt().toString()}%",
                    style: TextStyle(fontSize: 16),
                  ),
                if (dataPass.goal != 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _statusIncrement(),
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              (_numberChange >= 0) ? Pallete.green : Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                if (dataPass.goal != 0)
                  Slider(
                    min: 0,
                    max: dataPass.goal.toDouble(),
                    value: _selectedSlider,
                    onChanged: (value) {
                      setState(() {
                        _selectedSlider = value;
                        _numberChange =
                            _selectedSlider - dataPass.goalsAchieved.toDouble();
                      });
                    },
                  ),

                // * Note text ------------------------
                if (dataPass.goal != 0)
                  const Text(
                    "Catatan",
                    style: TextStyle(fontSize: 16),
                  ),
                if (dataPass.goal != 0)
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
                if (dataPass.goal != 0)
                  (dataPass.isActive)
                      ? Consumer<ImproveProvider>(builder: (_, data, __) {
                          return (data.detailState == ViewState.busy)
                              ? Center(child: const CircularProgressIndicator())
                              : Center(
                                  child: HomeLikeButton(
                                      iconData:
                                          CupertinoIcons.check_mark_circled,
                                      text: "Update",
                                      tapTap: _incrementImprove),
                                );
                        })
                      : Center(
                          child: (_approver)
                              ? OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    primary: Pallete.green,
                                    shape: const StadiumBorder(),
                                    side:
                                        const BorderSide(color: Pallete.green),
                                  ),
                                  onPressed: _enablingImprove,
                                  icon: const Icon(CupertinoIcons.rocket),
                                  label: const Text("Aktifkan"))
                              : OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: const StadiumBorder(),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.xmark_circle),
                                  label: const Text("Item belum diaktifkan")),
                        ),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
