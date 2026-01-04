import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class AuthenticationService {
  /// Hash password using SHA-256 with a compile-time secret salt.
  /// This is one-way (cannot be decrypted).
  String hashPassword(String plain) {
    final secretKey = String.fromEnvironment(
      'PASSWORD_SECRET',
      defaultValue: 'default_secret',
    );
    final bytes = utf8.encode('$secretKey::$plain');
    return sha256.convert(bytes).toString(); // 64 hex chars
  }

  String encodePassword(String plain) {
    final secretKey = String.fromEnvironment('PASSWORD_SECRET', defaultValue: 'default_secret');
    final key = _deriveKeyFromSecret(secretKey);

    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plain, iv: iv);
    // return base64(iv + ciphertext)
    final combined = Uint8List.fromList(iv.bytes + encrypted.bytes);
    return base64.encode(combined);
  }

  String decodePassword(String encoded) {
    final secretKey = String.fromEnvironment
        ('PASSWORD_SECRET', defaultValue: 'default_secret');
    final key = _deriveKeyFromSecret(secretKey);
    try {
      final data = base64.decode(encoded);
      if (data.length < 17) throw FormatException('Invalid encrypted payload');

      // IV is first 16 bytes for AES
      final ivBytes = data.sublist(0, 16);
      final cipherBytes = data.sublist(16);

      final iv = IV(ivBytes);
      final encrypter = Encrypter(AES(key));

      final encrypted = Encrypted(cipherBytes);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      rethrow;
    }
  }
  
  // Encode (encrypt) plain text using AES-GCM with a key derived from the
  // `INDENTITY_SECRET` compile-time variable. Returns a base64 string that
  // contains IV + ciphertext.
  String encodeIndentityNumber(String plain) {
    final secretKey = String.fromEnvironment('INDENTITY_SECRET', defaultValue: 'default_secret');
    final key = _deriveKeyFromSecret(secretKey);

    final iv = IV.fromSecureRandom(12);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(plain, iv: iv);

    // return base64(iv + ciphertext)
    final combined = Uint8List.fromList(iv.bytes + encrypted.bytes);
    return base64.encode(combined);
  }

  // Decode (decrypt) the base64 string produced by `encodeIndentityNumber`.
  String decodeIndentityNumber(String encoded) {
    final secretKey = String.fromEnvironment('INDENTITY_SECRET', defaultValue: 'default_secret');
    final key = _deriveKeyFromSecret(secretKey);

    try {
      final data = base64.decode(encoded);
      if (data.length < 13) throw FormatException('Invalid encrypted payload');

      // IV is first 12 bytes for AES-GCM
      final ivBytes = data.sublist(0, 12);
      final cipherBytes = data.sublist(12);

      final iv = IV(ivBytes);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      final encrypted = Encrypted(cipherBytes);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      rethrow;
    }
  }

  // Derives a 32-byte AES key from the provided secret string by UTF-8
  // encoding and padding/truncating to 32 bytes. This avoids adding extra
  // dependencies for key derivation; for stronger derivation consider using
  // HKDF/PBKDF2 via package:crypto or another KDF.
  Key _deriveKeyFromSecret(String secret) {
    final bytes = utf8.encode(secret);
    final List<int> keyBytes;
    if (bytes.length >= 32) {
      keyBytes = bytes.sublist(0, 32);
    } else {
      keyBytes = List<int>.from(bytes);
      keyBytes.addAll(List.filled(32 - keyBytes.length, 0));
    }
    return Key(Uint8List.fromList(keyBytes));
  }
}