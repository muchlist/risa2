import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/json_models/request/improve_change_req.dart';
import '../../api/json_models/response/improve_list_resp.dart';
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

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();

  late double _selectedSlider;
  double _numberChange = 0.0;

  String _statusIncrement() {
    if (_numberChange >= 0) {
      return "Perubahan +${_numberChange.toInt()}";
    } else {
      return "Perubahan ${_numberChange.toInt()}";
    }
  }

  Future<void> _enablingImprove() {
    return Future<void>.delayed(Duration.zero, () {
      _improveProvider.enabling().onError((Object? error, _) {
        showToastError(context: context, message: error.toString());
      });
    });
  }

  void _incrementImprove() {
    if (_key.currentState?.validate() ?? false) {
      final int timeNow = DateTime.now().toInt();
      // Payload
      final ImproveChangeRequest payload = ImproveChangeRequest(
          increment: _numberChange.toInt(),
          note: noteController.text,
          time: timeNow);

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => _improveProvider
                  .incrementImprovement(
                      _improveProvider.improveDataPass?.id ?? "", payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil mengupdate improvement");
                }
              }).onError((Object? error, _) {
                if (error != null) {
                  showToastError(context: context, message: error.toString());
                }
              }));
    }
  }

  @override
  void initState() {
    _improveProvider = context.read<ImproveProvider>();
    _selectedSlider =
        _improveProvider.improveDataPass?.goalsAchieved.toDouble() ?? 0.0;
    _approver = App.getRoles().any((String element) {
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
    final ImproveMinResponse dataPass = _improveProvider.improveDataPass!;

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
                  "Judul",
                  style: TextStyle(fontSize: 16),
                ),
                verticalSpaceTiny,

                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
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
                verticalSpaceTiny,

                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dataPass.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                verticalSpaceMedium,
                if (dataPass.goal != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Pallete.green.withOpacity(0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Center(
                            child: Text(
                          "${(dataPass.goalsAchieved / dataPass.goal * 100).toInt().toString()} %",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                      horizontalSpaceMedium,
                      const Icon(Icons.arrow_forward),
                      horizontalSpaceMedium,
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: (_numberChange >= 0)
                                ? Pallete.green
                                : Colors.red[400],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Center(
                            child: Text(
                          "${(_selectedSlider / dataPass.goal * 100).toInt().toString()} %",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      )
                    ],
                  ),
                verticalSpaceMedium,
                // * Status pekerjaan text ------------------------
                if (dataPass.goal != 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _statusIncrement(),
                      style: TextStyle(
                        fontSize: 16,
                        color: (_numberChange >= 0)
                            ? Colors.blueGrey
                            : Colors.red[400],
                      ),
                    ),
                  ),
                if (dataPass.goal != 0)
                  Slider(
                    max: dataPass.goal.toDouble(),
                    value: _selectedSlider,
                    onChanged: (double value) {
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
                verticalSpaceTiny,
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
                      ? Consumer<ImproveProvider>(
                          builder: (_, ImproveProvider data, __) {
                          return (data.detailState == ViewState.busy)
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: HomeLikeButton(
                                      iconData:
                                          CupertinoIcons.check_mark_circled,
                                      text: "Update",
                                      tapTap: _incrementImprove),
                                );
                        })
                      : Center(
                          child: _approver
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
