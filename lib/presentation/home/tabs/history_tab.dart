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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'history_search_placeholder'.tr,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              prefixIcon: const Icon(Icons.search, size: 18),
                            ),
                            onChanged: (_) {
                              // Triggered by searchController listener with debounce
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Start Date
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: controller.startDate.value,
                              firstDate: DateTime(2020),
                              lastDate: controller.endDate.value,
                            );
                            if (picked != null) {
                              controller.selectStartDate(picked);
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Từ ngày',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        controller.formattedStartDate,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('→', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      // End Date
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: controller.endDate.value,
                              firstDate: controller.startDate.value,
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              controller.selectEndDate(picked);
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Đến ngày',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        controller.formattedEndDate,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: controller.selectedStatus.value,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                selectedItemBuilder: (context) {
                                  return [
                                    Text(
                                      'history_all_status'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'history_in_building'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'history_left'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  ];
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('history_all_status'.tr, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w400)),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('history_in_building'.tr, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w400)),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('history_left'.tr, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w400)),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  controller.selectStatus(value);
                                },
                              ),
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
                          child: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () => controller.exportHistoryToExcel(),
                        icon: const Icon(
                          Icons.download,
                          size: 16,
                          color: AppColors.blueDark,
                        ),
                        label: const Text(
                          'Xuất Excel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.blueDark,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.blueDark),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
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
                  // Pagination
                  Obx(() {
                    final total = controller.totalCount.value;
                    final totalPages = controller.totalPages;
                    final start = total > 0
                        ? (controller.currentPage.value - 1) *
                                  controller.pageSize +
                              1
                        : 0;
                    final end = total > 0
                        ? (start + controller.historyList.length - 1).clamp(
                            0,
                            total,
                          )
                        : 0;

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
                            InkWell(
                              onTap: controller.currentPage.value > 1
                                  ? () => controller.previousPage()
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller.currentPage.value > 1
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: controller.currentPage.value > 1
                                      ? Colors.white
                                      : Colors.grey.shade100,
                                ),
                                child: Text(
                                  'Trước',
                                  style: TextStyle(
                                    color: controller.currentPage.value > 1
                                        ? Colors.black87
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ...List.generate(totalPages.clamp(0, 5), (index) {
                              final pageNum = index + 1;
                              final isCurrent =
                                  controller.currentPage.value == pageNum;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => controller.goToPage(pageNum),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isCurrent
                                          ? AppColors.blueDark
                                          : Colors.white,
                                      border: Border.all(
                                        color: isCurrent
                                            ? AppColors.blueDark
                                            : Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '$pageNum',
                                      style: TextStyle(
                                        color: isCurrent
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            InkWell(
                              onTap: controller.currentPage.value < totalPages
                                  ? () => controller.nextPage()
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        controller.currentPage.value <
                                            totalPages
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      controller.currentPage.value < totalPages
                                      ? Colors.white
                                      : Colors.grey.shade100,
                                ),
                                child: Text(
                                  'Sau',
                                  style: TextStyle(
                                    color:
                                        controller.currentPage.value <
                                            totalPages
                                        ? Colors.black87
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
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
