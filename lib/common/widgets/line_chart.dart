import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsChart extends StatefulWidget {
  const AnalyticsChart(
      {super.key, required this.allSpots, required this.highest});

  final List<FlSpot> allSpots;
  final int highest;

  @override
  State<AnalyticsChart> createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  late List<int> showingTooltipOnSpots;

  @override
  void initState() {
    super.initState();
    showingTooltipOnSpots = [
      widget.allSpots.indexWhere((spot) =>
          spot.y ==
          widget.allSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b)),
      widget.allSpots.indexWhere((spot) =>
          spot.y ==
          widget.allSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b))
    ];
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).extension<CustomColors>()?.text,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = context.tr('week.sun');
        break;
      case 1:
        text = context.tr('week.mon');
        break;
      case 2:
        text = context.tr('week.tue');
        break;
      case 3:
        text = context.tr('week.wed');
        break;
      case 4:
        text = context.tr('week.thu');
        break;
      case 5:
        text = context.tr('week.fri');
        break;
      case 6:
        text = context.tr('week.sat');
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: widget.allSpots,
        isCurved: false,
        barWidth: 1,
        color: const Color.fromARGB(255, 222, 184, 252), // barWidth의 색깔 조정
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color.fromARGB(0, 222, 184, 252),
                    const Color.fromARGB(0, 222, 184, 252),
                  ]
                : [
                    const Color.fromARGB(255, 222, 184, 252),
                    const Color.fromARGB(255, 236, 213, 252),
                    const Color.fromARGB(255, 250, 243, 255),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        dotData: const FlDotData(show: false),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(
            LineChartData(
              showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return;
                  }
                  if (event is FlTapUpEvent) {
                    final spotIndex = response.lineBarSpots!.first.spotIndex;
                    setState(() {
                      if (showingTooltipOnSpots.contains(spotIndex)) {
                        showingTooltipOnSpots.remove(spotIndex);
                      } else {
                        showingTooltipOnSpots = [spotIndex];
                      }
                    });
                  }
                },
                mouseCursorResolver:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return SystemMouseCursors.basic;
                  }
                  return SystemMouseCursors.click;
                },
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      const FlLine(
                        color: const Color.fromARGB(255, 157, 64, 239),
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: const Color.fromARGB(255, 157, 64, 239),
                          strokeWidth: 0,
                        ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipPadding:
                      EdgeInsets.symmetric(horizontal: 11.0, vertical: 3.0),
                  getTooltipColor: (touchedSpot) =>
                      Theme.of(context).extension<CustomColors>()?.primary ??
                      Colors.transparent,
                  tooltipRoundedRadius: 5,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      return LineTooltipItem(
                        lineBarSpot.y.toString(),
                        TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: 0,
              maxY: widget.highest + (widget.highest / 3),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
              ),
              gridData: const FlGridData(
                show: true,
                drawHorizontalLine: false,
                verticalInterval: 1.0,
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
