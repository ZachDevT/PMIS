// Reusable Components Section
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/features/pmis/css/widgets/kpicard.dart';
import 'package:pmis/features/pmis/css/pseudodata/pseudodata.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CssDashboardSection extends StatelessWidget {
  final data = PseudoData();

  CssDashboardSection({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child:MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: data.kpi.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              final kpi = data.kpi[index];
              return KpiCard(
                icon: kpi.icone,
                label: kpi.feature,
                number: kpi.number,
              );
            },
          ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: dark ? Tcolors.darkerGrey : Tcolors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    dark ? Tcolors.darkerGrey : Tcolors.grey.withOpacity(0.8),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activities Overview",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 170,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10, // Adjust based on your data range
                      minY: 0,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              String text;
                              switch (value.toInt()) {
                                case 0:
                                  text = 'J-M';
                                  break;
                                case 1:
                                  text = 'A-J';
                                  break;
                                case 2:
                                  text = 'J-S';
                                  break;
                                case 3:
                                  text = 'N-D';
                                  break;
                                default:
                                  text = '';
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(text, style: style),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              );
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(value.toString(), style: style),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(
                            toY: 2,
                            color: Tcolors.primary,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                            toY: 4,
                            color: Tcolors.primaryDark,
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                            toY: 3,
                            color: Tcolors.primary.withOpacity(0.8),
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                            toY: 6,
                            color: Tcolors.primaryDark.withOpacity(0.8),
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
