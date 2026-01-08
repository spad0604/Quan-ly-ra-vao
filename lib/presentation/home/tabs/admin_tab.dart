part of '../home_view.dart';

class AdminTab extends GetView<AdminController> {
  const AdminTab({super.key});

  @override
  Widget build(BuildContext context) {
    // If the current admin is not the default 'admin', hide create/list UI and show a notice.
    if (!controller.canManageAdmins) {
      return Column(
        children: [
          HomeHeader(
            title: 'Quản lý tài khoản Admin',
            subtitle: 'Tạo và quản lý các account admin trong hệ thống',
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(24),
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
                child: const Text(
                  'Bạn không có quyền quản lý Admin.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        HomeHeader(
          title: 'Quản lý tài khoản Admin',
          subtitle: 'Tạo và quản lý các account admin trong hệ thống',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildCreateCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: _buildListCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          const Text(
            'Thêm admin mới',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Chỉ tạo tài khoản admin (không cần các vai trò khác).',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 16),
          _field('Họ và tên', controller.fullNameController),
          const SizedBox(height: 12),
          _field('Tên đăng nhập', controller.usernameController),
          const SizedBox(height: 12),
          _field('Số điện thoại (tuỳ chọn)', controller.phoneController),
          const SizedBox(height: 12),
          _field(
            'Mật khẩu',
            controller.passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          _field(
            'Xác nhận mật khẩu',
            controller.confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.createAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tạo tài khoản',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách admin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(
                width: 280,
                height: 40,
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên / username',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isTableLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.admins.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Không có admin',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              );
            }

            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(2.2),
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.3),
                4: FixedColumnWidth(120),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade50),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'HỌ TÊN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'USERNAME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'TRẠNG THÁI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'NGÀY TẠO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'THAO TÁC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ...controller.admins.map((a) {
                  final isActive = a.status == 'ACTIVE';
                  final color = isActive ? Colors.green : Colors.red;
                  final dateStr = a.createdAt == null
                      ? '--/--/----'
                      : DateFormat('dd/MM/yyyy').format(a.createdAt!);
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          a.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(a.username),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Hoạt động' : 'Đã khoá',
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(dateStr),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: isActive ? 'Khoá' : 'Mở khoá',
                              onPressed: () => controller.toggleStatus(a),
                              icon: Icon(
                                isActive ? Icons.lock : Icons.lock_open,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Xoá',
                              onPressed: () => controller.showDeleteConfirmation(a),
                              icon: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            final total = controller.totalCount.value;
            final start = total == 0 ? 0 : ((controller.currentPage.value - 1) * controller.pageSize + 1);
            final end = total == 0
                ? 0
                : (start + controller.admins.length - 1);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hiển thị $start-$end trong tổng số $total kết quả',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: controller.currentPage.value > 1
                          ? () => controller.goToPage(controller.currentPage.value - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('${controller.currentPage.value}/${controller.totalPages}'),
                    IconButton(
                      onPressed: controller.currentPage.value < controller.totalPages
                          ? () => controller.goToPage(controller.currentPage.value + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                )
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    {bool obscureText = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}


