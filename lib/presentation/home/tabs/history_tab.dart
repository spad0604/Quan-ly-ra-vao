part of '../home_view.dart';

class HistoryTab extends GetView<HistoryController> {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeader(
          title: 'history_entry_exit'.tr,
          subtitle: 'history_track_details'.tr,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Tabs
                  Obx(
                    () => Row(
                      children: [
                        InkWell(
                          onTap: () => controller.changeFilter(0),
                          child: _buildTabButton(
                            'history_staff'.tr,
                            controller.selectedFilter.value == 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () => controller.changeFilter(1),
                          child: _buildTabButton(
                            'history_visitor'.tr,
                            controller.selectedFilter.value == 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),

                  // Filter Bar
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'history_search_placeholder'.tr,
                              border: InputBorder.none,
                              icon: const Icon(Icons.search, size: 18),
                            ),
                            onChanged: (_) {
                              // Triggered by searchController listener with debounce
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: controller.selectedDate.value,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              controller.selectDate(picked);
                            }
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(controller.formattedDate)),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => ListTile(
                                      title: Text('history_all_status'.tr),
                                      onTap: () {
                                        controller.selectStatus(0);
                                        Get.back();
                                      },
                                      trailing: controller.selectedStatus.value == 0
                                          ? const Icon(Icons.check, color: AppColors.blueDark)
                                          : null,
                                    )),
                                    Obx(() => ListTile(
                                      title: Text('history_in_building'.tr),
                                      onTap: () {
                                        controller.selectStatus(1);
                                        Get.back();
                                      },
                                      trailing: controller.selectedStatus.value == 1
                                          ? const Icon(Icons.check, color: AppColors.blueDark)
                                          : null,
                                    )),
                                    Obx(() => ListTile(
                                      title: Text('history_left'.tr),
                                      onTap: () {
                                        controller.selectStatus(2);
                                        Get.back();
                                      },
                                      trailing: controller.selectedStatus.value == 2
                                          ? const Icon(Icons.check, color: AppColors.blueDark)
                                          : null,
                                    )),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(controller.statusText)),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => controller.fetchHistory(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.blueDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Table
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.historyList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Chưa có dữ liệu lịch sử'),
                        ),
                      );
                    }

                    return Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FlexColumnWidth(2.5),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'history_staff_label'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Text(
                              'dashboard_department'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'history_time_in'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'history_time_out'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'dashboard_status'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        ...controller.historyList.map(
                          (item) => _buildHistoryRow(
                            item.name,
                            item.role == 'member'
                                ? 'Cán bộ'
                                : 'Khách', // Simple role text
                            item.department,
                            DateFormat(
                              'HH:mm dd/MM/yyyy',
                            ).format(item.checkInTime),
                            item.checkOutTime != null
                                ? DateFormat(
                                    'HH:mm dd/MM/yyyy',
                                  ).format(item.checkOutTime!)
                                : '--:--',
                            item.status,
                            item.statusColor,
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),
                  // Pagination placeholder
                  Obx(() {
                    final total = controller.historyList.length;
                    final start = total > 0 ? 1 : 0;
                    final end = total;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'history_showing_results'.tr
                              .replaceAll('{start}', start.toString())
                              .replaceAll('{end}', end.toString())
                              .replaceAll('{total}', total.toString()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.chevron_left, size: 16),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              color: AppColors.blueDark,
                              alignment: Alignment.center,
                              child: const Text(
                                '1',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Center(child: Text('2')),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.chevron_right, size: 16),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.badge : Icons.badge_outlined,
                color: isSelected ? AppColors.blueDark : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? AppColors.blueDark : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          width: 120,
          color: isSelected ? AppColors.blueDark : Colors.transparent,
        ),
      ],
    );
  }

  TableRow _buildHistoryRow(
    String name,
    String role,
    String dept,
    String timeIn,
    String timeOut,
    String status,
    Color color,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(dept, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(timeIn, style: const TextStyle(fontSize: 12)),
        Text(timeOut, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: color),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
