part of '../home_view.dart';

class DashboardTab extends GetView<DashboardController> {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(
          title: 'dashboard_overview'.tr,
          subtitle: 'dashboard_subtitle'.tr,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(),
                const SizedBox(height: 24),
                // Main Content Area: Chart + Right Panel
                // Use IntrinsicHeight to make them match height if desired,
                // but usually chart has fixed height.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildChartSection()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildRightPanel()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildStaffTableSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Obx(
      () => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StatCard(
                title: 'dashboard_total_staff'.tr,
                value: '${controller.totalStaff}',
                icon: Icons.people_outline,
                iconColor: Colors.blue,
                trendText:
                    '↗ +${controller.newStaff} ${'dashboard_new_staff'.tr}',
                trendColor: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'dashboard_guests_today'.tr,
                value: '${controller.guestsToday}',
                subtext: 'dashboard_checked_in'.tr,
                icon: Icons.badge_outlined,
                iconColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'dashboard_in_building'.tr,
                value: '${controller.inBuilding}',
                icon: Icons.apartment,
                iconColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dashboard_traffic_flow'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'dashboard_last_7_days'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.trafficRange.value,
                      items: [
                        DropdownMenuItem(
                          value: 'week',
                          child: Text('${'dashboard_this_week'.tr}'),
                        ),
                        DropdownMenuItem(
                          value: 'month',
                          child: Text('${'dashboard_this_month'.tr}'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) controller.setTrafficRange(v);
                      },
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(
            () => Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  '${controller.totalTraffic}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+${controller.trafficGrowth}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'dashboard_vs_last_week'.tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Obx(() {
              if (controller.trafficData.isEmpty) {
                return Center(
                  child: Text(
                    'Chưa có dữ liệu',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              }
              return CustomPaint(
                painter: _TrafficChartPainter(controller.trafficData),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Promo Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code_2, color: Colors.white, size: 40),
              const SizedBox(height: 16),
              Text(
                'dashboard_quick_qr_scan'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'dashboard_qr_description'.tr,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<HomeController>().selectedIndex.value = 2;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E88E5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'dashboard_do_now'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Recent Activity
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'dashboard_recent_activity'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<HomeController>().selectedIndex.value = 3;
                        },
                        child: Text(
                          'dashboard_view_all'.tr,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.recentEntriesWithNames.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'no_data'.tr,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                else
                  ...controller.recentEntriesWithNames.map((item) {
                    final entry = item['entry'] as TimeManagementTableData;
                    final name = item['name'] as String;
                    final timeFormat = DateFormat('HH:mm');
                    final checkInTimeStr = timeFormat.format(entry.checkInTime);
                    return _buildActivityItem(
                      name,
                      checkInTimeStr,
                      entry.status == 'ENTRY' ? 'ENTRY' : 'EXIT',
                      entry.status == 'ENTRY' ? Colors.green : Colors.red,
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String name,
    String time,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaffTableSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dashboard_staff_present_today'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Removed inline filter/export buttons per UX request
              const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.todayStaffPresent.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Không có dữ liệu',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              );
            }

            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FixedColumnWidth(50),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'dashboard_full_name'.tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'dashboard_department'.tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'dashboard_time_in'.tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'dashboard_status'.tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'dashboard_action'.tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ...controller.todayStaffPresent.map((staff) {
                  final timeStr = staff.checkInTime != null
                      ? '${staff.checkInTime!.hour.toString().padLeft(2, '0')}:${staff.checkInTime!.minute.toString().padLeft(2, '0')}'
                      : '--:--';
                  final statusText = staff.isPresent
                      ? 'dashboard_working'.tr
                      : 'dashboard_absent'.tr;
                  final statusColor = staff.isPresent
                      ? Colors.green
                      : Colors.grey;

                  return _buildTableRow(
                    staff.name,
                    staff.department.isEmpty
                        ? 'Chưa có phòng ban'
                        : staff.department,
                    timeStr,
                    statusText,
                    statusColor,
                  );
                }).toList(),
              ],
            );
          }),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    String name,
    String dept,
    String time,
    String status,
    Color color,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Text(dept, style: const TextStyle(color: Colors.grey)),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 6, color: color),
                const SizedBox(width: 4),
                Text(status, style: TextStyle(color: color, fontSize: 11)),
              ],
            ),
          ),
        ),
        const Icon(Icons.more_horiz, color: Colors.grey),
      ],
    );
  }
}

class _TrafficChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  
  _TrafficChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      // Empty state is handled by parent widget
      return;
    }

    // Extract counts from data
    final counts = data.map((d) => d['count'] as int).toList();
    
    // Find max count for scaling (add some padding at top)
    final maxCount = counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b);
    final maxValue = maxCount > 0 ? maxCount * 1.2 : 10; // 20% padding

    // Convert data points to chart coordinates
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final count = counts[i];
      // Invert Y: 0 count = bottom, max count = top
      final y = size.height - (count / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    // Create smooth path using cubic bezier curves
    final path = Path();
    if (points.isEmpty) return;
    
    path.moveTo(points[0].dx, points[0].dy);
    
    // Draw smooth curves between points
    for (int i = 1; i < points.length; i++) {
      if (i == 1) {
        // First curve: use quadratic for smooth start
        final controlPoint = Offset(
          (points[i - 1].dx + points[i].dx) / 2,
          (points[i - 1].dy + points[i].dy) / 2,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          points[i].dx,
          points[i].dy,
        );
      } else {
        // Use cubic bezier for smoother curves
        final prevPoint = points[i - 1];
        final currentPoint = points[i];
        final nextPoint = i < points.length - 1 ? points[i + 1] : currentPoint;
        
        // Control points for smooth curve
        final cp1 = Offset(
          prevPoint.dx + (currentPoint.dx - prevPoint.dx) * 0.5,
          prevPoint.dy,
        );
        final cp2 = Offset(
          currentPoint.dx - (nextPoint.dx - currentPoint.dx) * 0.5,
          currentPoint.dy,
        );
        
        path.cubicTo(
          cp1.dx,
          cp1.dy,
          cp2.dx,
          cp2.dy,
          currentPoint.dx,
          currentPoint.dy,
        );
      }
    }

    // Draw filled area first (so line appears on top)
    final fillPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF2196F3).withOpacity(0.25),
          const Color(0xFF2196F3).withOpacity(0.05),
          const Color(0xFF2196F3).withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw the line on top
    final linePaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrafficChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
