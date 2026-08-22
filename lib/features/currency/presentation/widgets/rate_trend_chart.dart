import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RateTrendChart extends StatefulWidget {
  const RateTrendChart({super.key});

  @override
  State<RateTrendChart> createState() => _RateTrendChartState();
}

class _RateTrendChartState extends State<RateTrendChart> {
  final Map<TrendPeriod, List<FlSpot>> dummyData = {
    TrendPeriod.W: const [
      FlSpot(0, 150.10),
      FlSpot(1, 150.05),
      FlSpot(2, 150.20),
      FlSpot(3, 150.15),
      FlSpot(4, 150.40),
      FlSpot(5, 150.30),
      FlSpot(6, 150.55),
    ],

    TrendPeriod.M: const [
      FlSpot(0, 149.80),
      FlSpot(1, 150.10),
      FlSpot(2, 149.95),
      FlSpot(3, 150.40),
      FlSpot(4, 150.20),
      FlSpot(5, 150.70),
      FlSpot(6, 150.50),
      FlSpot(7, 150.90),
      FlSpot(8, 150.60),
      FlSpot(9, 151.00),
      FlSpot(10, 150.80),
      FlSpot(11, 151.20),
      FlSpot(12, 151.05),
      FlSpot(13, 151.40),
      FlSpot(14, 151.25),
      FlSpot(15, 151.60),
      FlSpot(16, 151.30),
      FlSpot(17, 151.80),
      FlSpot(18, 151.50),
      FlSpot(19, 151.90),
      FlSpot(20, 151.70),
      FlSpot(21, 152.00),
      FlSpot(22, 151.80),
      FlSpot(23, 152.20),
      FlSpot(24, 152.00),
      FlSpot(25, 152.30),
      FlSpot(26, 152.10),
      FlSpot(27, 152.40),
      FlSpot(28, 152.20),
      FlSpot(29, 152.50),
    ],

    TrendPeriod.Y: const [
      FlSpot(0, 145.0),
      FlSpot(1, 147.0),
      FlSpot(2, 146.0),
      FlSpot(3, 149.0),
      FlSpot(4, 148.0),
      FlSpot(5, 151.0),
      FlSpot(6, 150.0),
      FlSpot(7, 153.0),
      FlSpot(8, 152.0),
      FlSpot(9, 155.0),
      FlSpot(10, 154.0),
      FlSpot(11, 157.0),
    ],
  };
  TrendPeriod selectedPeriod = TrendPeriod.W;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9BDB5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$selectedDays -day trend"),
              Row(
                children: TrendPeriod.values.map((period) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selectedPeriod == period
                            ? Colors.deepOrangeAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "1${period.name}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: currentData.length - 1,

                lineBarsData: [
                  LineChartBarData(
                    spots: currentData,
                    isCurved: true,
                    color: Colors.deepOrangeAccent,
                    barWidth: 3,
                    isStrokeCapRound: false,

                    dotData: const FlDotData(show: false),

                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepOrangeAccent.withOpacity(0.08),
                    ),
                  ),
                ],

                gridData: const FlGridData(show: false),

                borderData: FlBorderData(show: false),

                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get selectedDays {
    switch (selectedPeriod) {
      case TrendPeriod.W:
        return 7;
      case TrendPeriod.M:
        return 30;
      case TrendPeriod.Y:
        return 365;
    }
  }

  List<FlSpot> get currentData {
    return dummyData[selectedPeriod]!;
  }
}

enum TrendPeriod { W, M, Y }
