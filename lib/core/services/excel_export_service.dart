import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:intl/intl.dart';

class ExcelExportService {
  final _authenticationService = AuthenticationService();

  /// Export staff list to Excel
  Future<String?> exportStaffList(List<MemberTableData> members) async {
    try {
      final excel = Excel.createExcel();
      excel.delete('Sheet1');
      final sheet = excel['Danh sách cán bộ'];

      // Headers
      final headers = [
        'STT',
        'Họ và tên',
        'Số CCCD',
        'Ngày sinh',
        'Quê quán',
        'Giới tính',
        'Số hiệu sĩ quan',
        'Cấp bậc',
        'Chức vụ',
        'Đơn vị công tác',
        'Số điện thoại',
      ];

      // Write headers
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }

      // Write data
      for (int i = 0; i < members.length; i++) {
        final member = members[i];
        
        // Decode identity number
        String identityNumber = '';
        try {
          identityNumber = _authenticationService.decodeIndentityNumber(member.identityNumber);
        } catch (e) {
          identityNumber = member.identityNumber;
        }

        // Get department name
        String departmentName = member.departmentId;
        if (departmentName.isEmpty) {
          departmentName = 'Chưa có phòng ban';
        }

        final row = i + 1;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = IntCellValue(i + 1);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(member.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(identityNumber);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(member.dateOfBirth);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(member.address);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(member.sex);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = TextCellValue(member.officerNumber.isEmpty ? '' : member.officerNumber);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = TextCellValue(member.rank.isEmpty ? '' : member.rank);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = TextCellValue(member.position.isEmpty ? '' : member.position);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row)).value = TextCellValue(departmentName);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row)).value = TextCellValue(member.phoneNumber.isEmpty ? '' : member.phoneNumber);
      }

      // Auto-size columns
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnWidth(i, 15);
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/Danh_sach_can_bo_$timestamp.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      return filePath;
    } catch (e) {
      print('Error exporting staff list: $e');
      return null;
    }
  }

  /// Export history (entry/exit logs) to Excel
  Future<String?> exportHistory(List<Map<String, dynamic>> historyList, {bool isStaff = true}) async {
    try {
      final excel = Excel.createExcel();
      excel.delete('Sheet1');
      final sheetName = isStaff ? 'Lịch sử cán bộ' : 'Lịch sử khách';
      final sheet = excel[sheetName];

      // Headers
      final headers = isStaff
          ? [
              'STT',
              'Họ và tên',
              'Số CCCD',
              'Thời gian vào',
              'Thời gian ra',
              'Trạng thái',
            ]
          : [
              'STT',
              'Họ và tên',
              'Số CCCD',
              'Thời gian vào',
              'Lý do',
            ];

      // Write headers
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }

      // Write data
      for (int i = 0; i < historyList.length; i++) {
        final item = historyList[i];
        final row = i + 1;

        // Decode identity number
        String identityNumber = '';
        try {
          identityNumber = _authenticationService.decodeIndentityNumber(item['identity_number'] ?? '');
        } catch (e) {
          identityNumber = item['identity_number'] ?? '';
        }

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = IntCellValue(i + 1);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(item['name'] ?? '');
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(identityNumber);

        if (isStaff) {
          final checkInTime = item['check_in_time'] != null
              ? DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['check_in_time'] * 1000))
              : '';
          final checkOutTime = item['check_out_time'] != null
              ? DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['check_out_time'] * 1000))
              : '';
          final status = item['check_out_time'] != null ? 'Đã ra' : 'Đang trong';

          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(checkInTime);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(checkOutTime);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(status);
        } else {
          final checkInTime = item['check_in_time'] != null
              ? DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['check_in_time'] * 1000))
              : '';
          final reason = item['reason'] ?? '';

          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(checkInTime);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(reason);
        }
      }

      // Auto-size columns
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnWidth(i, 20);
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileTypeStr = isStaff ? 'can_bo' : 'khach';
      final filePath = '${directory.path}/Lich_su_ra_vao_${fileTypeStr}_$timestamp.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      return filePath;
    } catch (e) {
      print('Error exporting history: $e');
      return null;
    }
  }
}

