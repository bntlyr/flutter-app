import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

/// RSA-OAEP SHA-256 encryption matching backend `pemDecrypt`.
class RsaEncryptor {
  /// Encrypts [plainText] with [pemPublicKey] using RSA-OAEP (SHA-256).
  /// Returns a Base64-encoded ciphertext string.
  static String encrypt({
    required String plainText,
    required String pemPublicKey,
  }) {
    if (plainText.isEmpty) return '';

    final pubKey = parsePemPublicKey(pemPublicKey);
    final cipher = OAEPEncoding.withSHA256(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(pubKey));

    final inputBytes = Uint8List.fromList(utf8.encode(plainText));
    final encryptedBytes = cipher.process(inputBytes);

    return base64.encode(encryptedBytes);
  }

  /// Parses SubjectPublicKeyInfo PEM string to [RSAPublicKey].
  static RSAPublicKey parsePemPublicKey(String pem) {
    final cleanPem = pem
        .replaceAll('-----BEGIN PUBLIC KEY-----', '')
        .replaceAll('-----END PUBLIC KEY-----', '')
        .replaceAll(RegExp(r'\s+'), '');

    final bytes = base64.decode(cleanPem);
    final asn1Parser = ASN1Parser(bytes);
    final topSeq = asn1Parser.nextObject() as ASN1Sequence;
    final bitString = topSeq.elements![1] as ASN1BitString;

    // Skip the first byte (unused bits count in DER BitString)
    final rsaBytes = bitString.valueBytes!.sublist(1);
    final rsaParser = ASN1Parser(rsaBytes);
    final rsaSeq = rsaParser.nextObject() as ASN1Sequence;

    final modulus = rsaSeq.elements![0] as ASN1Integer;
    final exponent = rsaSeq.elements![1] as ASN1Integer;

    return RSAPublicKey(modulus.integer!, exponent.integer!);
  }
}
