# Running the Windows build under Wine (Linux)

How to run the CI Windows artifact on a Linux machine to smoke-test it. Wine
is not Windows: fonts, DPI and the GPU path can differ, so a result under Wine
proves the app starts and draws, not that it is correct on Windows.

## 1. Install Wine (64-bit)

The `wine` binary on Ubuntu/Debian is often 32-bit only. The app is a 64-bit
PE (`file ebalistyka.exe` → `PE32+ ... x86-64`), so it needs `wine64`:

```bash
sudo apt install wine64
```

If `wine64` is not in the repos, use the WineHQ packages instead.

Check the install:

```bash
wine64 --version
```

## 2. Get the Windows build from CI

The `Build Windows MSIX + Portable` job uploads a `portable` zip. Download it
for a run (replace `<RUN_ID>` with the run's database id):

```bash
gh run list --branch <branch> --workflow "Build Windows MSIX + Portable" --limit 3
gh run download <RUN_ID> --repo o-murphy/ebalistyka --dir ./ci-windows
```

The artifact is named like `ebalistyka-windows-x86_64-<version>-pr.<n>-<run>`.
Inside it: `portable/ebalistyka_windows_x86_64.zip`.

Unpack it into a fresh folder, not into the repo:

```bash
mkdir -p ~/wine-test/app
unzip -q ./ci-windows/portable/ebalistyka_windows_x86_64.zip -d ~/wine-test/app
```

## 3. Use a separate Wine prefix

Keep the test away from your own Wine configuration. A prefix is the Wine
"C: drive" directory, here created next to the app:

```bash
export WINEPREFIX=~/wine-test/prefix
export WINEARCH=win64
export WINEDEBUG=-all
```

The first run creates the prefix (takes a minute).

## 4. Run it

```bash
cd ~/wine-test/app
timeout 150 wine64 ./ebalistyka.exe
```

`timeout` stops the app after 150 s so a hung window does not stay open.
Exit code `124` means it was still running when the timeout hit (a normal
result for this check); any other non-zero code is a failure.

To see the window, run it with a display (the normal desktop session), and
take a screenshot of it with your tool of choice. The window title should be
`eBalistyka`, outer size 375×812.

## Known noise

- `Warning: D3D shader compilation failed with skip optimization flags.` is
  harmless under Wine; the app still renders.
- Running `wine` (the 32-bit binary) on this app gives
  `Не може бути запущено... неправильний формат EXE` (not a valid Win32
  application). Use `wine64`.
- The first run may create `~/.wine32` if `wine` (32-bit) is used by mistake.
  It is safe to delete.

## Cleanup

```bash
rm -rf ~/wine-test
```

## Not covered by this check

- Minimum window size and the second-launch raise on Windows are not
  implemented yet (see [0017](records/0017-drop-window-manager.md)); a test
  run cannot check them.
- Real Windows behaviour (DPI scaling, MSIX install, the Start menu) needs a
  Windows machine.
