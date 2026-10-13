import 'dart:convert';
import 'dart:typed_data';

import 'package:ebc_db/src/persistence/msg_store.dart';
import 'package:test/test.dart';

class _MemStore extends MsgStore<String> {
  _MemStore({super.debounce})
    : super(
        encode: (s) => Uint8List.fromList(utf8.encode(s)),
        decode: utf8.decode,
      );

  Uint8List? bytes;
  int writes = 0;

  @override
  Future<Uint8List?> readBytes() async => bytes;

  @override
  Future<void> writeBytes(Uint8List b) async {
    writes++;
    bytes = b;
  }
}

void main() {
  group('MsgStore.writesBlocked', () {
    test('writes normally while not blocked', () async {
      final s = _MemStore();
      await s.save('a');
      expect(s.writes, 1);
      expect(await s.load(orElseSeed: () => 'seed'), 'a');
    });

    test('save is dropped once blocked, stored value is untouched', () async {
      final s = _MemStore();
      await s.save('a');
      s.writesBlocked = true;
      await s.save('b');
      expect(s.writes, 1);
      expect(await s.load(orElseSeed: () => 'seed'), 'a');
    });

    test('a debounced write pending at block time is dropped', () async {
      final s = _MemStore(debounce: const Duration(milliseconds: 20));
      final pending = s.save('a');
      s.writesBlocked = true;
      await pending; // completes, without writing
      expect(s.writes, 0);
      expect(s.bytes, isNull);
    });

    test('flush while blocked does not write', () async {
      final s = _MemStore(debounce: const Duration(seconds: 10));
      unawaited(s.save('a'));
      s.writesBlocked = true;
      await s.flush();
      expect(s.writes, 0);
    });

    test('reads still work while blocked', () async {
      final s = _MemStore();
      await s.save('a');
      s.writesBlocked = true;
      expect(await s.load(orElseSeed: () => 'seed'), 'a');
    });

    test('writes resume after unblocking', () async {
      final s = _MemStore();
      s.writesBlocked = true;
      await s.save('a');
      s.writesBlocked = false;
      await s.save('b');
      expect(s.writes, 1);
      expect(await s.load(orElseSeed: () => 'seed'), 'b');
    });
  });
}

void unawaited(Future<void> f) {}
