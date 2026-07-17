import 'dart:typed_data';

import 'msg_codec.dart';
import 'proto/ebcp.pb.dart' as proto;

abstract final class EbcpFile {
  static final _codec = MsgCodec<proto.EbcpData>(
    toBuffer: (data) => data.writeToBuffer(),
    fromBuffer: proto.EbcpData.fromBuffer,
  );

  static Uint8List encode(proto.EbcpData data) => _codec.encode(data);

  /// Throws [MsgParseException] on any error.
  static proto.EbcpData decode(Uint8List bytes) => _codec.decode(bytes);
}
