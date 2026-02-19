#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path


def pick_label(requested: str, index: int) -> str:
    if requested and requested != "auto":
        return requested
    if index == 1:
        return "initial"
    if index == 2:
        return "after-feedback"
    if index == 3:
        return "final"
    return f"iteration-{index}"


def main() -> None:
    parser = argparse.ArgumentParser(description="Create artifact snapshot version")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--label", default="auto")
    args = parser.parse_args()

    out_dir = Path(args.out_dir).resolve()
    version_root = out_dir / ".versions"
    version_root.mkdir(parents=True, exist_ok=True)

    existing = []
    for d in version_root.iterdir():
        if not d.is_dir() or not d.name.startswith("v"):
            continue
        prefix = d.name[1:].split("-", 1)[0]
        if prefix.isdigit():
            existing.append(int(prefix))

    next_idx = max(existing, default=0) + 1
    label = pick_label(args.label, next_idx)
    version_name = f"v{next_idx}-{label}"
    target = version_root / version_name
    target.mkdir(parents=True, exist_ok=True)

    for p in out_dir.iterdir():
        if not p.is_file():
            continue
        if p.suffix.lower() not in {".json", ".md", ".css", ".yaml", ".svg"}:
            continue
        shutil.copy2(p, target / p.name)

    index_path = version_root / "index.json"
    index_obj = {"versions": []}
    if index_path.exists():
        try:
            raw = json.loads(index_path.read_text(encoding="utf-8"))
            if isinstance(raw, dict) and isinstance(raw.get("versions"), list):
                index_obj = raw
        except Exception:
            pass

    index_obj["versions"].append(
        {
            "version": version_name,
            "label": label,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "artifact_count": len([x for x in target.iterdir() if x.is_file()]),
        }
    )
    index_path.write_text(json.dumps(index_obj, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    changelog_path = out_dir / "CHANGELOG.md"
    lines = []
    if changelog_path.exists():
        lines = changelog_path.read_text(encoding="utf-8").splitlines()
    if not lines:
        lines = ["# Artifact Changelog", ""]
    lines.extend(
        [
            f"- created_at: {datetime.now(timezone.utc).isoformat()}",
            f"- version: {version_name}",
            f"- note: Fullflow pipeline artifact snapshot ({label})",
            "",
        ]
    )
    changelog_path.write_text("\n".join(lines), encoding="utf-8")
    shutil.copy2(changelog_path, target / "CHANGELOG.md")

    print(version_name)


if __name__ == "__main__":
    main()
