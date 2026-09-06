# Windows msix auto-update blocked by self-signed cert

**Status:** Not scheduled

The `.appinstaller`-based auto-update path for the Windows msix package is
blocked: it requires a trusted CA-signed certificate, and the current
signing is self-signed. No trusted CA has been sourced yet. Part of the
broader auto-update work tracked under [0001].
