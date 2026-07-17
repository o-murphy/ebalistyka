import 'dart:typed_data';

import 'msg_codec.dart';
import 'proto/settings.pb.dart' as proto;

abstract final class SettingsFile {
  static final _codec = MsgCodec<proto.SettingsData>(
    toBuffer: (data) => data.writeToBuffer(),
    fromBuffer: proto.SettingsData.fromBuffer,
  );

  static Uint8List encode(proto.SettingsData data) => _codec.encode(data);

  /// Throws [MsgParseException] on any error.
  static proto.SettingsData decode(Uint8List bytes) => _codec.decode(bytes);
}
