import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// Wire format shared by every message type in this package — "md5+ebcpbuf":
// [32 bytes MD5 hex string]["ebcpbuf" payload, i.e. plain protobuf bytes of
// one of this package's messages]. The MD5 is stored as ASCII hex (e.g.
// "d41d8cd98f00b204e9800998ecf8427e"), not as 16 raw binary bytes — same
// convention as .a7p (see o-murphy/a7p's A7pFile).

class MsgParseException implements Exception {
  final String reason;
  const MsgParseException(this.reason);

  @override
  String toString() => 'message parse error: $reason';
}

/// Generic hash-prefixed protobuf codec, parametrized by one message type's
/// own `writeToBuffer()`/`fromBuffer()` — every persisted/shared message in
/// this package (`ProfilesData`, `SettingsData`, …) uses the same wire
/// convention, so the encode/decode/hash-check logic lives here once.
class MsgCodec<T> {
  final Uint8List Function(T) _toBuffer;
  final T Function(Uint8List) _fromBuffer;

  const MsgCodec({
    required Uint8List Function(T) toBuffer,
    required T Function(Uint8List) fromBuffer,
  }) : _toBuffer = toBuffer,
       _fromBuffer = fromBuffer;

  Uint8List encode(T message) {
    final pb = _toBuffer(message);
    final hexHash = md5.convert(pb).toString(); // 32-char hex string
    return Uint8List.fromList([...ascii.encode(hexHash), ...pb]);
  }

  /// Throws [MsgParseException] on any error.
  T decode(Uint8List bytes) {
    if (bytes.length < 32) {
      throw const MsgParseException('file too small');
    }

    final storedHex = ascii.decode(bytes.sublist(0, 32), allowInvalid: true);
    final pbAfterHex = bytes.sublist(32);
    if (storedHex != md5.convert(pbAfterHex).toString()) {
      throw const MsgParseException('hash mismatch — not a valid file');
    }

    try {
      return _fromBuffer(pbAfterHex);
    } catch (e) {
      throw MsgParseException('protobuf decode failed: $e');
    }
  }
}
