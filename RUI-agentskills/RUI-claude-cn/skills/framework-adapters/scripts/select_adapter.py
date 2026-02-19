#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Dict, List


FRAMEWORK_MAP = {
    "react": "react-adapter",
    "next": "react-adapter",
    "vue": "vue-adapter",
    "angular": "angular-adapter",
    "svelte": "svelte-adapter",
}


def collect_files(root: Path) -> List[str]:
    if not root.exists():
        return []
    files = [p for p in root.rglob("*") if p.is_file()]
    return [str(p.relative_to(root)) for p in sorted(files)]


def copy_templates(adapter_root: Path, target_root: Path) -> List[str]:
    copied: List[str] = []
    for rel in collect_files(adapter_root):
        src = adapter_root / rel
        dst = target_root / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_text(src.read_text(encoding="utf-8", errors="ignore"), encoding="utf-8")
        copied.append(str(dst.relative_to(target_root.parent)))
    return copied


def main() -> None:
    parser = argparse.ArgumentParser(description="Select framework adapter and emit manifest")
    parser.add_argument("--framework", required=True)
    parser.add_argument("--repo-root", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--emit-templates", action="store_true")
    args = parser.parse_args()

    framework = args.framework.strip().lower()
    repo_root = Path(args.repo_root).resolve()
    out_dir = Path(args.out_dir).resolve()
    manifest_path = Path(args.manifest).resolve()

    adapters_root = repo_root / "skills" / "framework-adapters"
    adapter_name = FRAMEWORK_MAP.get(framework, "react-adapter")
    adapter_root = adapters_root / adapter_name

    templates = collect_files(adapter_root / "templates")
    hooks = collect_files(adapter_root / "hooks")
    composables = collect_files(adapter_root / "composables")
    services = collect_files(adapter_root / "services")
    stores = collect_files(adapter_root / "stores")

    emitted = []
    if args.emit_templates:
        emit_root = out_dir / "framework-adapter"
        emitted = copy_templates(adapter_root, emit_root)

    manifest: Dict[str, object] = {
        "framework": framework,
        "adapter": adapter_name,
        "adapter_root": str(adapter_root.relative_to(repo_root)),
        "assets": {
            "templates": templates,
            "hooks": hooks,
            "composables": composables,
            "services": services,
            "stores": stores,
        },
        "emitted": emitted,
    }

    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
