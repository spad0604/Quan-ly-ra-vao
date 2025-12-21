enum ManagementEnum {
  entry,
  exit;

  String get nameVn {
    switch (this) {
      case ManagementEnum.entry:
        return 'Đang vào';
      case ManagementEnum.exit:
        return 'Đã ra về';
    }
  }

  String get code {
    switch (this) {
      case ManagementEnum.entry:
        return 'ENTRY';
      case ManagementEnum.exit:
        return 'EXIT';
    }
  }

  static ManagementEnum fromCode(String code) {
    switch (code) {
      case 'ENTRY':
        return ManagementEnum.entry;
      case 'EXIT':
        return ManagementEnum.exit;
      default:
        throw ArgumentError('Invalid code: $code');
    }
  }
}