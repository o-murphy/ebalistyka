@TestOn('browser')
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:ebc_db/src/persistence/indexed_db_msg_store.dart';
import 'package:test/test.dart';

IndexedDbMsgStore<String> _store(String key, IndexedDbWriteFence? fence) =>
    IndexedDbMsgStore<String>(
      key,
      encode: (s) => Uint8List.fromList(utf8.encode(s)),
      decode: utf8.decode,
      fence: fence,
    );

Future<String?> _read(String key) async {
  final bytes = await _store(key, null).readBytes();
  return bytes == null ? null : utf8.decode(bytes);
}

void main() {
  // IndexedDB persists across tests in the same browser profile; use unique
  // keys per test so they don't see each other's data.
  var n = 0;
  String key() => 'fence-test-${DateTime.now().microsecondsSinceEpoch}-${n++}';

  test('claim() hands out strictly increasing epochs', () async {
    final a = IndexedDbWriteFence();
    final b = IndexedDbWriteFence();
    final ea = await a.claim();
    final eb = await b.claim();
    expect(eb, greaterThan(ea));
    expect(a.epoch, ea);
    expect(b.epoch, eb);
  });

  test('the current owner can write', () async {
    final k = key();
    final fence = IndexedDbWriteFence();
    await fence.claim();
    await _store(k, fence).save('mine');
    expect(await _read(k), 'mine');
    expect(fence.isStale, isFalse);
  });

  test('a stale owner\'s write is rejected, data untouched', () async {
    final k = key();
    var staleCalls = 0;
    final oldOwner = IndexedDbWriteFence(onStale: () => staleCalls++);
    await oldOwner.claim();
    final oldStore = _store(k, oldOwner);
    await oldStore.save('before');
    expect(await _read(k), 'before');

    final newOwner = IndexedDbWriteFence();
    await newOwner.claim();
    await _store(k, newOwner).save('new owner');

    // The old page tries to write after the takeover.
    await oldStore.save('zombie write');

    expect(await _read(k), 'new owner');
    expect(oldOwner.isStale, isTrue);
    expect(staleCalls, 1);
  });

  test('a write in flight at the takeover cannot land', () async {
    final k = key();
    final oldOwner = IndexedDbWriteFence();
    await oldOwner.claim();
    final oldStore = _store(k, oldOwner);

    // Kick off the old owner's write, then take over before awaiting it.
    final inFlight = oldStore.save('in flight');
    final newOwner = IndexedDbWriteFence();
    await newOwner.claim();
    await _store(k, newOwner).save('new owner');
    await inFlight;

    // Whichever transaction ran first, the new owner's value must win or the
    // old one must have been rejected: the final value can never be the old
    // owner's write landing *after* the new owner's.
    expect(await _read(k), 'new owner');
  });

  test('an unfenced store still writes', () async {
    final k = key();
    await _store(k, null).save('plain');
    expect(await _read(k), 'plain');
  });

  test('reads are never fenced', () async {
    final k = key();
    final owner = IndexedDbWriteFence();
    await owner.claim();
    await _store(k, owner).save('x');
    await IndexedDbWriteFence().claim(); // owner is now stale
    expect(await _store(k, owner).readBytes(), isNotNull);
  });
}
