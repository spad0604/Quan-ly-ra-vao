import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/core/services/print_service.dart';

class QrDataDialog extends StatefulWidget {
  final String title;
  final String name;
  final String? subtitle;
  final String qrData;
  final String? idLabel;

  const QrDataDialog({
    super.key,
    required this.title,
    required this.name,
    this.subtitle,
    required this.qrData,
    this.idLabel,
  });

  @override
  State<QrDataDialog> createState() => _QrDataDialogState();
}

class _QrDataDialogState extends State<QrDataDialog> {
  final _printService = PrintService();
  bool _isPrinting = false;

  Future<void> _handlePrint() async {
    setState(() {
      _isPrinting = true;
    });

    try {
      await _printService.printGuestQR(
        guestName: widget.name,
        qrData: widget.qrData,
        guestId: widget.qrData,
        subtitle: widget.subtitle,
      );
      if (mounted) {
        Get.snackbar(
          'Thành công',
          'Đã gửi lệnh in QR code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Lỗi',
          'Không thể in QR code: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 133,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.idLabel ?? 'ID: ${widget.qrData.length > 8 ? widget.qrData.substring(0, 8) : widget.qrData}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPrinting ? null : _handlePrint,
                    icon: _isPrinting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.print),
                    label: Text(_isPrinting ? 'Đang in...' : 'In QR Code'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: AppColors.blueDark),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'close'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


