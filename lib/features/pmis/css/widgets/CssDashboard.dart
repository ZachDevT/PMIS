import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pmis/utils/constants/colors.dart';
import 'package:pmis/features/pmis/css/widgets/kpicard.dart';
import 'package:pmis/features/pmis/css/controllers/CssController.dart';
import 'package:pmis/features/pmis/gpp/controllers/GppController.dart';
import 'package:pmis/features/pmis/gdp/controllers/GdpController.dart';
import 'package:pmis/features/pmis/pmsa/controllers/PmsaController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CssDashboardSection extends StatelessWidget {
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [Tcolors.darkerGrey, Tcolors.darkerGrey.withOpacity(0.8)]
                    : [Colors.white, Tcolors.grey.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Tcolors.primary, Tcolors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Tcolors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.dashboard_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Overview',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      dark ? Colors.white : Tcolors.darkerGrey,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Current month activity summary',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: dark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final cssController = Get.find<CssController>();
                  final gppController = Get.find<GppController>();
                  final gdpController = Get.find<GdpController>();
                  final pmsaController = Get.find<PmsaController>();

                  final kpiData = [
                    {
                      'icon': HugeIcons.strokeRoundedMedicineBottle02,
                      'label': 'CSS',
                      'count': cssController.activities.length,
                      'color': Tcolors.secondarySecond,
                      'subtitle': 'Compliant Support Suppervision'
                    },
                    {
                      'icon': HugeIcons.strokeRoundedMedicine02,
                      'label': 'GPP',
                      'count': gppController.activities.length,
                      'color': Colors.blue,
                      'subtitle': 'Good Pharmacy Practice'
                    },
                    {
                      'icon': HugeIcons.strokeRoundedDeliveryTracking01,
                      'label': 'GDP',
                      'count': gdpController.activities.length,
                      'color': Colors.blue,
                      'subtitle': 'Good Distribution Practice'
                    },
                    {
                      'icon': Iconsax.activity,
                      'label': 'PMSA',
                      'count': pmsaController.activities.length,
                      'color': Tcolors.secondarySecond,
                      'subtitle': 'Post Market Surveillance'
                    },
                  ];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: kpiData.length,
                    itemBuilder: (context, index) {
                      final kpi = kpiData[index];
                      return _buildEnhancedKpiCard(
                        context,
                        icon: kpi['icon'] as IconData,
                        label: kpi['label'] as String,
                        count: kpi['count'] as int,
                        color: kpi['color'] as Color,
                        subtitle: kpi['subtitle'] as String,
                        dark: dark,
                      );
                    },
                  );
                }),
              ],
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
            // padding: const EdgeInsets.all(20),
            padding:
                const EdgeInsets.only(left: 15, right: 10, bottom: 15, top: 5),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Yearly Overview",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 15),
                Obx(() {
                  final cssController = Get.find<CssController>();
                  final gppController = Get.find<GppController>();
                  final gdpController = Get.find<GdpController>();
                  final pmsaController = Get.find<PmsaController>();

                  final chartData = _generateYearlyChartData(
                    cssController.activities,
                    gppController.activities,
                    gdpController.activities,
                    pmsaController.activities,
                  );

                  return SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: chartData['maxY'].toDouble(),
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
                                  fontSize: 15,
                                );
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(value.toInt().toString(),
                                      style: style),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: chartData['barGroups'],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedKpiCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required String subtitle,
    required bool dark,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [Tcolors.darkerGrey.withOpacity(0.8), Tcolors.darkerGrey]
              : [Colors.white, color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark ? Colors.grey.withOpacity(0.2) : color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                dark ? Colors.black.withOpacity(0.2) : color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${count}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Tcolors.darkerGrey,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 10,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (count / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _generateYearlyChartData(
    List<dynamic> cssActivities,
    List<dynamic> gppActivities,
    List<dynamic> gdpActivities,
    List<dynamic> pmsaActivities,
  ) {
    // Group activities by quarter
    Map<int, int> quarterlyCount = {};

    // Process all activities
    List<List<dynamic>> allActivities = [
      cssActivities,
      gppActivities,
      gdpActivities,
      pmsaActivities
    ];

    for (var activityList in allActivities) {
      for (var activity in activityList) {
        DateTime inspectionDate;
        if (activity.inspectionDate is DateTime) {
          inspectionDate = activity.inspectionDate;
        } else {
          inspectionDate = DateTime.parse(activity.inspectionDate.toString());
        }

        int quarter;
        if (inspectionDate.month >= 1 && inspectionDate.month <= 3) {
          quarter = 0; // J-M
        } else if (inspectionDate.month >= 4 && inspectionDate.month <= 6) {
          quarter = 1; // A-J
        } else if (inspectionDate.month >= 7 && inspectionDate.month <= 9) {
          quarter = 2; // J-S
        } else {
          quarter = 3; // N-D
        }

        quarterlyCount[quarter] = (quarterlyCount[quarter] ?? 0) + 1;
      }
    }

    // Generate bar groups
    List<BarChartGroupData> barGroups = [];
    int maxY = 0;

    for (int i = 0; i < 4; i++) {
      int count = quarterlyCount[i] ?? 0;
      maxY = count > maxY ? count : maxY;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: i % 2 == 0 ? Tcolors.primary : Tcolors.primaryDark,
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return {
      'barGroups': barGroups,
      'maxY': maxY > 0 ? maxY : 1,
    };
  }
}
