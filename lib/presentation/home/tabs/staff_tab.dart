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
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined, size: 16),
                label: const Text('Lọc Phòng Ban'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => controller.openAddDepartmentPopup(),
                icon: const Icon(Icons.add_business, size: 16),
                label: const Text('Thêm Phòng Ban'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Xuất Excel'),
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
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Thêm cán bộ mới'),
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
          ListView.separated(
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
                          Text('Phòng Hành chính', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('Chuyên viên', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Pagination
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Hiển thị 1-5 trên 150 kết quả', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Trước'),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.blueDark, borderRadius: BorderRadius.circular(4)),
                  child: const Text('1', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: const Text('2'),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Sau'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
