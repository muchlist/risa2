import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../globals.dart';
import '../../providers/dashboard.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/utils.dart';

class GeneratePdfDialog extends StatefulWidget {
  const GeneratePdfDialog();

  @override
  _GeneratePdfDialogState createState() => _GeneratePdfDialogState();
}

class _GeneratePdfDialogState extends State<GeneratePdfDialog> {
  late bool _isVendor = App.getRoles().contains("VENDOR");
  DateTime? _startDateSelected;
  DateTime? _endDateSelected;

  void _generatePdf(int start, int end, {bool forVendor = false}) {
    // Call Provider
    Future<void>.delayed(
        Duration.zero,
        () => context
                .read<DashboardProvider>()
                .generatePDF(start, end, forVendor)
                .then((bool value) {
              if (value) {
                Navigator.of(context).pop();
                showToastSuccess(
                    context: context, message: "Berhasil membuat pdf");
              }
            }).onError((error, _) {
              if (error != null) {
                showToastError(context: context, message: error.toString());
              }
            }));
  }

  String getDateString(DateTime? _dateSelected, bool isStart) {
    if (_dateSelected == null) {
      if (isStart) {
        return "Tentukan waktu mulai";
      } else {
        return "Tentukan waktu akhir";
      }
    }
    return _dateSelected.toInt().getCompleteDateString();
  }

  void _showDateTimePickerStart() {
    DatePicker.showDateTimePicker(context,
        locale: LocaleType.id,
        minTime: DateTime(DateTime.now().year - 10),
        maxTime: DateTime(DateTime.now().year + 1), onConfirm: (DateTime date) {
      setState(() {
        _startDateSelected = date;
      });
    }, currentTime: _startDateSelected);
  }

  void _showDateTimePickerEnd() {
    DatePicker.showDateTimePicker(context,
        locale: LocaleType.id,
        minTime: DateTime(DateTime.now().year - 10),
        maxTime: DateTime(DateTime.now().year + 1), onConfirm: (DateTime date) {
      setState(() {
        _endDateSelected = date;
      });
    }, currentTime: _endDateSelected);
  }

  @override
  Widget build(BuildContext context) {
    final height = screenHeight(context);
    var isPortrait = screenIsPortrait(context);

    return Container(
      height: (isPortrait) ? height * 0.5 : height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Range tanggal laporan:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    verticalSpaceMedium,
                    GestureDetector(
                      onTap: _showDateTimePickerStart,
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
                                getDateString(_startDateSelected, true),
                              ),
                              const Icon(CupertinoIcons.calendar),
                            ]),
                      ),
                    ),
                    verticalSpaceMedium,
                    GestureDetector(
                      onTap: _showDateTimePickerEnd,
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
                                getDateString(_endDateSelected, false),
                              ),
                              const Icon(CupertinoIcons.calendar),
                            ]),
                      ),
                    ),
                    verticalSpaceMedium,
                    Center(
                      child: HomeLikeButton(
                          iconData: CupertinoIcons.printer,
                          text: "Generate",
                          tapTap: () {
                            if (_startDateSelected == null ||
                                _endDateSelected == null) {
                              showToastError(
                                  context: context,
                                  message: "Pilih tanggal terlebih dahulu!!");
                            } else {
                              _generatePdf(_startDateSelected!.toInt(),
                                  _endDateSelected!.toInt(),
                                  forVendor: _isVendor);
                            }
                          }),
                    ),
                    verticalSpaceLarge,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
