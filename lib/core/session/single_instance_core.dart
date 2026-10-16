import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

const _lockFileName = 'instance.lock';
const _portFileName = 'instance.port';
const _activateMessage = 'ebalistyka:activate';

// Kept for the life of the process — the OS drops the lock (and the socket)
// when it exits, however it exits, so a crash never leaves a stale lock.
final _keepAlive = <Object>[];

/// Takes the instance lock in [dir] and starts listening for activation
/// requests. `false` if another process holds the lock. Any other failure
/// (e.g. a file system without locking) counts as "primary" — better to run
/// unguarded than not to start.
Future<bool> tryBecomePrimary(
  Directory dir, {
  required Future<void> Function() onActivate,
}) async {
  final RandomAccessFile handle;
  try {
    handle = await File('${dir.path}/$_lockFileName')
        .open(mode: FileMode.append);
  } catch (e) {
    log('single instance: cannot open lock file: $e');
    return true;
  }
  try {
    await handle.lock(FileLock.exclusive);
  } on FileSystemException {
    await handle.close();
    return false;
  }
  _keepAlive.add(handle);

  try {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    _keepAlive.add(server);
    await File('${dir.path}/$_portFileName').writeAsString('${server.port}');
    server.listen((socket) {
      unawaited(
        utf8.decoder
            .bind(socket)
            .join()
            .then((message) async {
              if (message.trim() == _activateMessage) {
                try {
                  await onActivate();
                } catch (e) {
                  log('single instance: activate failed: $e');
                }
              }
            })
            .catchError((Object e) {
              log('single instance: bad activation request: $e');
            })
            .whenComplete(socket.destroy),
      );
    });
  } catch (e) {
    // Still the primary (we hold the lock); a later launch just can't raise us.
    log('single instance: activation socket unavailable: $e');
  }
  return true;
}

/// Asks the instance that holds the lock in [dir] to raise its window.
/// The port file may not be written yet if both processes start together, so
/// retry briefly.
Future<bool> notifyRunningInstance(Directory dir) async {
  final portFile = File('${dir.path}/$_portFileName');
  for (var attempt = 0; attempt < 20; attempt++) {
    try {
      final port = int.tryParse((await portFile.readAsString()).trim());
      if (port != null) {
        final socket = await Socket.connect(
          InternetAddress.loopbackIPv4,
          port,
          timeout: const Duration(seconds: 2),
        );
        socket.write(_activateMessage);
        await socket.flush();
        await socket.close();
        socket.destroy();
        return true;
      }
    } catch (_) {
      // not there yet / stale — retry
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return false;
}
