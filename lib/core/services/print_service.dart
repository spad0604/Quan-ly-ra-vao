import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class PrintService {
  /// Print QR code for staff member
  Future<void> printStaffQR({
    required String memberName,
    required String position,
    required String qrData,
    required String memberId,
  }) async {
    try {
      // Generate QR code image
      final qrImage = await _generateQRImage(qrData, size: 200);

      // Create PDF document
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header
                pw.Text(
                  'BỘ ĐỘI BIÊN PHÒNG TỈNH LAI CHÂU',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'MÃ QR CÁN BỘ',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),

                // Member info
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey700, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        memberName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      if (position.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          position,
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

                // QR Code
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrImage),
                    width: 200,
                    height: 200,
                  ),
                ),
                pw.SizedBox(height: 16),

                // Member ID
                pw.Text(
                  'ID: $memberId',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),

                // Footer
                pw.Text(
                  'Quét mã QR này để check-in/check-out',
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

      // Check if printing is available
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
      // Generate QR code image
      final qrImage = await _generateQRImage(qrData, size: 200);

      // Create PDF document
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Header
                pw.Text(
                  'BỘ ĐỘI BIÊN PHÒNG TỈNH LAI CHÂU',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'MÃ QR KHÁCH VÃNG LAI',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),

                // Guest info
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey700, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        guestName,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      if (subtitle != null && subtitle.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          subtitle,
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

                // QR Code
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrImage),
                    width: 200,
                    height: 200,
                  ),
                ),
                pw.SizedBox(height: 16),

                // Guest ID
                pw.Text(
                  'ID: ${guestId.length > 8 ? guestId.substring(0, 8) : guestId}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 24),

                // Footer
                pw.Text(
                  'Quét mã QR này để check-in/check-out',
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

      // Check if printing is available
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
  Future<Uint8List> _generateQRImage(String data, {int size = 200}) async {
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

