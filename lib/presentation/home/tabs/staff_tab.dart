part of '../home_view.dart';

class StaffTab extends GetView<StaffController> {
  const StaffTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(
          title: 'Quản lý Cán bộ',
          subtitle: 'Danh sách Cán bộ',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildFilterAndTableSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Tổng số cán bộ',
            value: '${controller.totalStaff}',
            icon: Icons.groups,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Cán bộ Nam',
            value: '${controller.maleStaff}',
            icon: Icons.male,
            iconColor: Colors.blueGrey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Cán bộ Nữ',
            value: '${controller.femaleStaff}',
            icon: Icons.female,
            iconColor: Colors.pinkAccent,
          ),
        ),
      ],
    ));
  }

  Widget _buildFilterAndTableSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm theo tên, số CCCD...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(() => OutlinedButton.icon(
                onPressed: () {
                  Get.dialog(
                    const FilterDepartmentDialog(),
                    barrierDismissible: true,
                  );
                },
                icon: Icon(
                  Icons.filter_alt_outlined,
                  size: 16,
                  color: controller.selectedDepartmentId.value != null
                      ? AppColors.blueDark
                      : Colors.grey,
                ),
                label: Text(
                  controller.selectedDepartmentId.value != null
                      ? 'Đã lọc'
                      : 'Lọc Phòng Ban',
                  style: TextStyle(
                    color: controller.selectedDepartmentId.value != null
                        ? AppColors.blueDark
                        : Colors.grey,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: controller.selectedDepartmentId.value != null
                        ? AppColors.blueDark
                        : Colors.grey.shade300,
                  ),
                ),
              )),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => controller.openAddDepartmentPopup(),
                icon: const Icon(Icons.add_business, size: 16, color: AppColors.blueDark),
                label: const Text('Thêm Phòng Ban', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.blueDark)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.blueDark,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16, color: AppColors.blueDark),
                label: const Text('Xuất Excel', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.blueDark)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.blueDark,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.openAddStaffPopup();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Thêm cán bộ mới', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.grey.shade50,
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Cán bộ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                Expanded(flex: 2, child: Text('Đơn vị công tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                Expanded(flex: 2, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey), textAlign: TextAlign.right)),
              ],
            ),
          ),
          
          // Table Rows
          Obx(() {
            if (controller.members.value.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'no_data'.tr,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.members.value.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (_, index) {
                final member = controller.members.value[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=1'), 
                            // In real app, handle image load error
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('ID: ${member.id}', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.departmentId.isNotEmpty ? member.departmentId : 'Chưa có phòng ban',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            member.position.isNotEmpty ? member.position : 'Chưa có chức vụ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code, color: Colors.green),
                            onPressed: () => controller.showQRCode(member),
                            tooltip: 'Xem QR Code',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => controller.openEditMemberPopup(member),
                            tooltip: 'Chỉnh sửa',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.showDeleteConfirmation(member),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              },
            );
          }),
          
          // Pagination
          Obx(() {
            final start = (controller.currentPageValue - 1) * controller.pageSizeValue + 1;
            final end = (start + controller.members.value.length - 1).clamp(0, controller.totalCount.value);
            final totalPages = controller.totalPages;
            
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Hiển thị $start-$end trên ${controller.totalCount.value} kết quả',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  // Previous button
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
                  // Page numbers
                  ...List.generate(
                    totalPages.clamp(0, 5), // Show max 5 pages
                    (index) {
                      final pageNum = index + 1;
                      final isCurrentPage = controller.currentPage.value == pageNum;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => controller.goToPage(pageNum),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCurrentPage
                                  ? AppColors.blueDark
                                  : Colors.white,
                              border: Border.all(
                                color: isCurrentPage
                                    ? AppColors.blueDark
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$pageNum',
                              style: TextStyle(
                                color: isCurrentPage
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Next button
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: controller.currentPage.value < totalPages
                        ? () => controller.nextPage()
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.currentPage.value < totalPages
                              ? Colors.grey.shade300
                              : Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: controller.currentPage.value < totalPages
                            ? Colors.white
                            : Colors.grey.shade100,
                      ),
                      child: Text(
                        'Sau',
                        style: TextStyle(
                          color: controller.currentPage.value < totalPages
                              ? Colors.black87
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
