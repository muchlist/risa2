import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/cctv_resp.dart';
import '../config/pallatte.dart';
import '../utils/utils.dart';

class CctvLineChart extends StatefulWidget {
  final CctvExtra data;

  const CctvLineChart({Key? key, required this.data}) : super(key: key);

  @override
  _CctvLineChartState createState() => _CctvLineChartState();
}

class _CctvLineChartState extends State<CctvLineChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Pallete.background),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 5,
            left: 10,
            child: Column(
              children: [
                Text(
                  "${widget.data.pingsState.last.time.getDateString()}",
                  style: TextStyle(
                    color: Color(0xff68737d),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${widget.data.pingsState.first.time.getDateString()}",
                  style: const TextStyle(
                    color: Color(0xff68737d),
                    fontSize: 12,
                  ),
                )
              ],
            ))
      ],
    );
  }

  LineChartData mainData() {
    // Generate data Chart
    // pingstate 0 yang terbaru sehingga perlu di reverse
    var listPing = widget.data.pingsState;
    listPing = listPing.reversed.toList();
    var chartData = <FlSpot>[];
    for (var i = 0; i < listPing.length; i++) {
      chartData.add(FlSpot(i.toDouble(), listPing[i].code.toDouble()));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Pallete.secondaryBackground,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Pallete.secondaryBackground,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontSize: 12,
          ),
          getTitles: (value) {
            // if (value.toInt() == 0) {
            //   final dateDisplay = listPing[0].time.getDateString();
            //   return "  " * dateDisplay.length + dateDisplay;
            // } else if (value.toInt() == listPing.length - 1) {
            //   final dateDisplay = listPing[value.toInt()].time.getDateString();
            //   return dateDisplay + "  " * dateDisplay.length;
            // } else {
            //   return '';
            // }
            return "";
          },
          margin: 4,
        ),
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'DO';
              case 2:
                return 'UP';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: Pallete.secondaryBackground, width: 1)),
      minX: 0,
      maxX: listPing.length - 1.toDouble(),
      minY: -1,
      maxY: 3,
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
