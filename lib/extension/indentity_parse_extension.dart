import 'package:quanly/data/models/indentity_card_model.dart';

extension IndentityParseExtension on String {
  IndentityCardModel toIndentityCardModel() {
    // CCCD QR commonly uses pipe delimiters.
    // Seen formats:
    // - id|fullName|dob(ddMMyyyy)|sex|address
    // - id|fullName|dob|sex|address|issueDate(ddMMyyyy)
    // - id||fullName|dob|sex|address|issueDate  (empty field after id)
    var parts = split('|');
    if (parts.length >= 2 && parts[1].trim().isEmpty) {
      // Drop the empty placeholder after id to normalize ordering.
      parts = <String>[parts[0], ...parts.skip(2)];
    }

    // Defensive defaults
    String indentityNumber = '';
    String fullName = '';
    String sex = '';
    String address = '';
    String createAt = '';

    if (parts.isNotEmpty) indentityNumber = parts[0].trim();

    // Prefer the common CCCD ordering: id|name|dob|sex|address(|issueDate)
    if (parts.length > 1) fullName = parts[1].trim();
    if (parts.length > 2) createAt = parts[2].trim(); // DOB
    if (parts.length > 3) sex = parts[3].trim();
    if (parts.length > 4) address = parts[4].trim();
    // parts[5] (issueDate) is currently unused in IndentityCardModel.

    return IndentityCardModel(
      indentityNumber: indentityNumber,
      fullName: fullName,
      sex: sex,
      address: address,
      createAt: createAt,
    );
  }
}