import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/speed_list_resp.dart';
import '../utils/utils.dart';
import 'ui_helpers.dart';

class LineChartSpeedTest extends StatefulWidget {
  const LineChartSpeedTest({Key? key, required this.data}) : super(key: key);
  final List<SpeedData> data;

  @override
  State<StatefulWidget> createState() => LineChartSpeedTestState();
}

class LineChartSpeedTestState extends State<LineChartSpeedTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = screenIsPortrait(context);

    return AspectRatio(
      aspectRatio: isPortrait ? 16 / 15 : 16 / 9,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceSmall,
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Speed Test Banjarmasin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    // textAlign: TextAlign.center,
                  ),
                ),
                verticalSpaceMedium,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 700),
                    ),
                  ),
                ),
                verticalSpaceSmall,
                if (widget.data.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth()
                      },
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          const Text(
                            "Download Speed",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          const Text("   :   ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          Text(
                            "${widget.data.last.download.toStringAsFixed(2)} mbps",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(color: Color(0xff4af699)),
                          ),
                        ]),
                        TableRow(children: <Widget>[
                          const Text("Upload Speed",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          const Text("   :   ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          Text(
                            "${widget.data.last.upload.toStringAsFixed(2)} mbps",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                        ]),
                        TableRow(children: <Widget>[
                          const Text("Latency",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          const Text("   :   ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          Text("${widget.data.last.latencyMs} ms",
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ]),
                        TableRow(children: <Widget>[
                          const Text("Recent Test",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          const Text("   :   ",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          Text(widget.data.last.time.getCompleteDateString(),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ]),
                      ],
                    ),
                  ),
                verticalSpaceRegular,
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (double value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (double value) {
            final int intValue = value.toInt();
            if (intValue == widget.data.length - 1) {
              return widget.data[intValue].time.getHourString();
            }
            if (intValue % 5 == 0 && intValue != widget.data.length) {
              return widget.data[intValue].time.getHourString();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (double value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (double value) {
            final int intValue = value.toInt();
            if (intValue % 10 == 0) {
              return '$intValue';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: widget.data.length.toDouble(),
      maxY: 70.0,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {
    // menambahkan data upload dan download,
    // konversi ke FlSpot
    final List<FlSpot> chartDataUpload = <FlSpot>[];
    final List<FlSpot> chartDataDownload = <FlSpot>[];
    for (int i = 0; i < widget.data.length; i++) {
      chartDataUpload.add(FlSpot(i.toDouble(),
          double.parse(widget.data[i].upload.toStringAsFixed(2))));
      chartDataDownload.add(FlSpot(i.toDouble(),
          double.parse(widget.data[i].download.toStringAsFixed(2))));
    }

    final LineChartBarData lineChartBarDownload = LineChartBarData(
      spots: chartDataDownload,
      isCurved: true,
      colors: <Color>[
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarUpload = LineChartBarData(
      spots: chartDataUpload,
      isCurved: true,
      colors: <Color>[
        Colors.blueAccent,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: <Color>[
        const Color(0x00aa4cfc),
      ]),
    );

    return <LineChartBarData>[
      lineChartBarDownload,
      lineChartBarUpload,
    ];
  }
}
