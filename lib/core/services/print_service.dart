import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrintService {
  static const int _qrSizeCurrent = 200;
  static const int _qrSize = 133; // ~= 2/3 of 200

  static const Map<String, String> _vnDiacriticMap = {
    'à': 'a',
    'á': 'a',
    'ạ': 'a',
    'ả': 'a',
    'ã': 'a',
    'â': 'a',
    'ầ': 'a',
    'ấ': 'a',
    'ậ': 'a',
    'ẩ': 'a',
    'ẫ': 'a',
    'ă': 'a',
    'ằ': 'a',
    'ắ': 'a',
    'ặ': 'a',
    'ẳ': 'a',
    'ẵ': 'a',
    'À': 'A',
    'Á': 'A',
    'Ạ': 'A',
    'Ả': 'A',
    'Ã': 'A',
    'Â': 'A',
    'Ầ': 'A',
    'Ấ': 'A',
    'Ậ': 'A',
    'Ẩ': 'A',
    'Ẫ': 'A',
    'Ă': 'A',
    'Ằ': 'A',
    'Ắ': 'A',
    'Ặ': 'A',
    'Ẳ': 'A',
    'Ẵ': 'A',
    'è': 'e',
    'é': 'e',
    'ẹ': 'e',
    'ẻ': 'e',
    'ẽ': 'e',
    'ê': 'e',
    'ề': 'e',
    'ế': 'e',
    'ệ': 'e',
    'ể': 'e',
    'ễ': 'e',
    'È': 'E',
    'É': 'E',
    'Ẹ': 'E',
    'Ẻ': 'E',
    'Ẽ': 'E',
    'Ê': 'E',
    'Ề': 'E',
    'Ế': 'E',
    'Ệ': 'E',
    'Ể': 'E',
    'Ễ': 'E',
    'ì': 'i',
    'í': 'i',
    'ị': 'i',
    'ỉ': 'i',
    'ĩ': 'i',
    'Ì': 'I',
    'Í': 'I',
    'Ị': 'I',
    'Ỉ': 'I',
    'Ĩ': 'I',
    'ò': 'o',
    'ó': 'o',
    'ọ': 'o',
    'ỏ': 'o',
    'õ': 'o',
    'ô': 'o',
    'ồ': 'o',
    'ố': 'o',
    'ộ': 'o',
    'ổ': 'o',
    'ỗ': 'o',
    'ơ': 'o',
    'ờ': 'o',
    'ớ': 'o',
    'ợ': 'o',
    'ở': 'o',
    'ỡ': 'o',
    'Ò': 'O',
    'Ó': 'O',
    'Ọ': 'O',
    'Ỏ': 'O',
    'Õ': 'O',
    'Ô': 'O',
    'Ồ': 'O',
    'Ố': 'O',
    'Ộ': 'O',
    'Ổ': 'O',
    'Ỗ': 'O',
    'Ơ': 'O',
    'Ờ': 'O',
    'Ớ': 'O',
    'Ợ': 'O',
    'Ở': 'O',
    'Ỡ': 'O',
    'ù': 'u',
    'ú': 'u',
    'ụ': 'u',
    'ủ': 'u',
    'ũ': 'u',
    'ư': 'u',
    'ừ': 'u',
    'ứ': 'u',
    'ự': 'u',
    'ử': 'u',
    'ữ': 'u',
    'Ù': 'U',
    'Ú': 'U',
    'Ụ': 'U',
    'Ủ': 'U',
    'Ũ': 'U',
    'Ư': 'U',
    'Ừ': 'U',
    'Ứ': 'U',
    'Ự': 'U',
    'Ử': 'U',
    'Ữ': 'U',
    'ỳ': 'y',
    'ý': 'y',
    'ỵ': 'y',
    'ỷ': 'y',
    'ỹ': 'y',
    'Ỳ': 'Y',
    'Ý': 'Y',
    'Ỵ': 'Y',
    'Ỷ': 'Y',
    'Ỹ': 'Y',
    'đ': 'd',
    'Đ': 'D',
  };

  String _stripVietnameseDiacritics(String input) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(_vnDiacriticMap[ch] ?? ch);
    }
    return buffer.toString();
  }

  /// Print QR code for staff member
  Future<void> printStaffQR({
    required String memberName,
    required String position,
    required String qrData,
    required String memberId,
  }) async {
    try {
      final safeMemberName = _stripVietnameseDiacritics(memberName);
      final safePosition = _stripVietnameseDiacritics(position);

      final qrImage = await _generateQRImage(qrData, size: _qrSize);
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  _stripVietnameseDiacritics('BỘ ĐỘI BIÊN PHÒNG TỈNH LAI CHÂU'),
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  _stripVietnameseDiacritics('MÃ QR CÁN BỘ'),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey700, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        safeMemberName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      if (safePosition.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          safePosition,
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrImage),
                    width: _qrSize.toDouble(),
                    height: _qrSize.toDouble(),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'ID: $memberId',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  _stripVietnameseDiacritics('Quét mã QR này để check-in/check-out'),
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            );
          },
        ),
      );

      final canPrint = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      if (!canPrint) {
        throw Exception('Không thể truy cập máy in. Vui lòng kiểm tra kết nối máy in hoặc cài đặt driver.');
      }
    } on MissingPluginException {
      throw Exception('Plugin in ấn chưa được khởi tạo. Vui lòng rebuild ứng dụng sau khi cài đặt package printing.');
    } catch (e) {
      throw Exception('Lỗi khi in QR code: $e');
    }
  }

  /// Print QR code for guest
  Future<void> printGuestQR({
    required String guestName,
    required String qrData,
    required String guestId,
    String? subtitle,
  }) async {
    try {
      final safeGuestName = _stripVietnameseDiacritics(guestName);
      final safeSubtitle = subtitle != null ? _stripVietnameseDiacritics(subtitle) : null;

      final qrImage = await _generateQRImage(qrData, size: _qrSize);
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  _stripVietnameseDiacritics('BỘ ĐỘI BIÊN PHÒNG TỈNH LAI CHÂU'),
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  _stripVietnameseDiacritics('MÃ QR KHÁCH VÃNG LAI'),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey700, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        safeGuestName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      if (safeSubtitle != null && safeSubtitle.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          safeSubtitle,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey700,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrImage),
                    width: _qrSize.toDouble(),
                    height: _qrSize.toDouble(),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'ID: ${guestId.length > 8 ? guestId.substring(0, 8) : guestId}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  _stripVietnameseDiacritics('Quét mã QR này để check-in/check-out'),
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            );
          },
        ),
      );

      final canPrint = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      if (!canPrint) {
        throw Exception('Không thể truy cập máy in. Vui lòng kiểm tra kết nối máy in hoặc cài đặt driver.');
      }
    } on MissingPluginException {
      throw Exception('Plugin in ấn chưa được khởi tạo. Vui lòng rebuild ứng dụng sau khi cài đặt package printing.');
    } catch (e) {
      throw Exception('Lỗi khi in QR code: $e');
    }
  }

  /// Generate QR code as image bytes
  Future<Uint8List> _generateQRImage(String data, {int size = _qrSizeCurrent}) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    final picRecorder = ui.PictureRecorder();
    final canvas = Canvas(picRecorder);
    final qrSize = Size(size.toDouble(), size.toDouble());
    painter.paint(canvas, qrSize);

    final picture = picRecorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}