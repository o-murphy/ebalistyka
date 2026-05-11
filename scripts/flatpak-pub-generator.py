#!/usr/bin/env python3
"""
Generate a flatpak sources JSON for all hosted Dart/pub packages
listed in pubspec.lock.

Usage:
    python3 flatpak-pub-generator.py pubspec.lock [-o pub-sources.json]

Each hosted package becomes an `archive` source that extracts into
  .pub-cache/hosted/pub.dev/<name>-<version>/
so `flutter pub get --offline` finds the cache without network access.
"""

import argparse
import json
import sys

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")


PUB_STORAGE = "https://storage.googleapis.com/pub-packages/packages"


def load_lockfile(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def generate_sources(lockfile: dict) -> list[dict]:
    sources = []
    packages = lockfile.get("packages", {})

    for name, info in sorted(packages.items()):
        if info.get("source") != "hosted":
            continue  # skip path / git / sdk packages

        version = info["version"]
        sha256 = info["description"].get("sha256")

        if not sha256:
            print(f"WARNING: no sha256 for {name}-{version}, skipping", file=sys.stderr)
            continue

        sources.append({
            "type": "archive",
            "url": f"{PUB_STORAGE}/{name}-{version}.tar.gz",
            "sha256": sha256,
            "dest": f".pub-cache/hosted/pub.dev/{name}-{version}",
            "strip-components": 0,
        })

    return sources


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lockfile", help="Path to pubspec.lock")
    parser.add_argument("-o", "--output", default="-", help="Output file (default: stdout)")
    args = parser.parse_args()

    lockfile = load_lockfile(args.lockfile)
    sources = generate_sources(lockfile)

    output = json.dumps(sources, indent=2)

    if args.output == "-":
        print(output)
    else:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(output)
        print(f"✓ Written {len(sources)} sources to {args.output}", file=sys.stderr)


if __name__ == "__main__":
    main()
