import 'dart:typed_data';

import '../proto/profiles.pb.dart' as proto;
import 'msg_codec.dart';

abstract final class ProfilesFile {
  static final _codec = MsgCodec<proto.ProfilesData>(
    toBuffer: (data) => data.writeToBuffer(),
    fromBuffer: proto.ProfilesData.fromBuffer,
  );

  static Uint8List encode(proto.ProfilesData data) => _codec.encode(data);

  /// Throws [MsgParseException] on any error.
  static proto.ProfilesData decode(Uint8List bytes) => _codec.decode(bytes);
}
