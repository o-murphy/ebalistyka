import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'proto/ebc_db.pb.dart' as proto;

// Wire format: [32 bytes MD5 hex string][protobuf bytes]. The MD5 is stored
// as ASCII hex (e.g. "d41d8cd98f00b204e9800998ecf8427e"), not as 16 raw
// binary bytes — same convention as .a7p (see o-murphy/a7p's A7pFile).

class DbParseException implements Exception {
  final String reason;
  const DbParseException(this.reason);

  @override
  String toString() => 'Db parse error: $reason';
}

abstract final class DbFile {
  static Uint8List encode(proto.Db db) {
    final pb = db.writeToBuffer();
    final hexHash = md5.convert(pb).toString(); // 32-char hex string
    return Uint8List.fromList([...ascii.encode(hexHash), ...pb]);
  }

  /// Throws [DbParseException] on any error.
  static proto.Db decode(Uint8List bytes) {
    if (bytes.length < 32) {
      throw const DbParseException('file too small');
    }

    final storedHex = ascii.decode(bytes.sublist(0, 32), allowInvalid: true);
    final pbAfterHex = bytes.sublist(32);
    if (storedHex == md5.convert(pbAfterHex).toString()) {
      try {
        return proto.Db.fromBuffer(pbAfterHex);
      } catch (e) {
        throw DbParseException('protobuf decode failed: $e');
      }
    }

    throw const DbParseException('hash mismatch — not a valid Db file');
  }
}
