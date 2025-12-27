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
                    Expanded(
                      flex: 3, 
                      child: _buildChartSection(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1, 
                      child: _buildRightPanel(),
                    ),
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
    return Obx(() => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatCard(
              title: 'dashboard_total_staff'.tr,
              value: '${controller.totalStaff}',
              icon: Icons.people_outline,
              iconColor: Colors.blue,
              trendText: '↗ +${controller.newStaff} ${'dashboard_new_staff'.tr}',
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
          const SizedBox(width: 16),
          Expanded(
            child: StatCard(
              title: 'dashboard_pending_requests'.tr,
              value: '${controller.pendingRequests}',
              trendText: 'dashboard_view_details'.tr,
              trendColor: Colors.blue,
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red,
            ),
          ),
        ],
      ),
    ));
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${'dashboard_this_week'.tr} ▾', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '${controller.totalTraffic}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '+${controller.trafficGrowth}%',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('dashboard_vs_last_week'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          )),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CustomPaint(
              painter: _ChartPlaceholderPainter(),
            ),
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'dashboard_qr_description'.tr,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E88E5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('dashboard_do_now'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('dashboard_recent_activity'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('dashboard_view_all'.tr, style: TextStyle(color: Colors.blue.shade700, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (index) {
                final items = [
                  ('Trần Thị B', 'Khách vãng lai • P. Hành chính', 'VÀO', '08:30', Colors.green),
                  ('Lê Văn C', 'Cán bộ • Ban Tuyên giáo', 'VÀO', '08:15', Colors.green),
                  ('Phạm Văn D', 'Khách vãng lai • P. Tài vụ', 'RA', '08:10', Colors.orange),
                  ('Nguyễn Thị E', 'Cán bộ • P. Kế toán', 'VÀO', '08:00', Colors.green),
                ];
                return _buildActivityItem(
                  items[index].$1,
                  items[index].$2,
                  items[index].$3,
                  items[index].$4,
                  items[index].$5,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String name, String detail, String status, String time, Color color) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(detail, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
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
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 16),
                    label: Text('filter'.tr),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: Text('dashboard_export_report'.tr),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
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
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                children: [
                  Padding(padding: const EdgeInsets.all(12), child: Text('dashboard_full_name'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
                  Text('dashboard_department'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('dashboard_time_in'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('dashboard_status'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('dashboard_action'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildTableRow('Hoàng Văn Thái', 'Phòng CNTT', '07:45', 'dashboard_working'.tr, Colors.green),
              _buildTableRow('Nguyễn Thị Mai', 'Văn phòng Sở', '07:55', 'dashboard_working'.tr, Colors.green),
              _buildTableRow('Trần Văn Vĩnh', 'Phòng Kế toán', '--:--', 'dashboard_absent'.tr, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String name, String dept, String time, String status, Color color) {
    return TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color.withOpacity(0.1),
                child: Text(name.substring(0, 1), style: TextStyle(color: color, fontSize: 12)),
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
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
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

class _ChartPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.6, 0, size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
    
    // Draw shading
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [Colors.blue.withOpacity(0.2), Colors.blue.withOpacity(0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
