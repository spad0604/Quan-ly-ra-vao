import 'package:quanly/data/models/indentity_card_model.dart';

extension IndentityParseExtension on String? {
  IndentityCardModel toIndentityCardModel(String rawData) {
    // The QR format uses pipe delimiters. Example:
    // id||Full Name|Sex|Address|CreatedAt
    // Splitting on '|' yields empty strings for double-pipe positions, so
    // we map the expected positions accordingly.
    final parts = rawData.split('|');

    // Defensive defaults
    String indentityNumber = '';
    String fullName = '';
    String sex = '';
    String address = '';
    String createAt = '';

    if (parts.isNotEmpty) {
      // parts[0] => id
      indentityNumber = parts[0].trim();
    }

    // For the sample format there is an empty part[1] (because of '||'),
    // then name at parts[2], sex at parts[3], address at parts[4], createAt at parts[5]
    if (parts.length > 2) fullName = parts[2].trim();
    if (parts.length > 3) sex = parts[3].trim();
    if (parts.length > 4) address = parts[4].trim();
    if (parts.length > 5) createAt = parts[5].trim();

    return IndentityCardModel(
      indentityNumber: indentityNumber,
      fullName: fullName,
      sex: sex,
      address: address,
      createAt: createAt,
    );
  }
}