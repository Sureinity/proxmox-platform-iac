#!/usr/bin/env python3
"""Generate the local Ansible inventory from the Terraform ansible_inventory output."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

import yaml


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Render ansible/inventories/prod/hosts.yml from Terraform output."
    )
    parser.add_argument(
        "--terraform-dir",
        default="terraform/live/prod/workloads",
        help="Terraform directory that exposes the ansible_inventory output.",
    )
    parser.add_argument(
        "--from-file",
        default=None,
        help="Optional path to a JSON file containing the ansible_inventory value.",
    )
    parser.add_argument(
        "--output",
        default="ansible/inventories/prod/hosts.yml",
        help="Inventory output path, or - for stdout.",
    )
    return parser.parse_args()


def load_inventory_from_terraform(terraform_dir: str) -> dict:
    result = subprocess.run(
        [
            "terraform",
            f"-chdir={terraform_dir}",
            "output",
            "-json",
            "ansible_inventory",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def load_inventory_from_file(path: str) -> dict:
    return json.loads(Path(path).read_text())


def validate_inventory_shape(inventory: dict) -> None:
    if not isinstance(inventory, dict):
        raise ValueError("Inventory output must be a JSON object.")

    all_group = inventory.get("all")
    if not isinstance(all_group, dict):
        raise ValueError("Inventory output must contain an 'all' object.")

    children = all_group.get("children")
    if not isinstance(children, dict):
        raise ValueError("Inventory output must contain all.children.")

    linux_group = children.get("linux")
    if not isinstance(linux_group, dict):
        raise ValueError("Inventory output must contain all.children.linux.")


def dump_inventory(inventory: dict, output_path: str) -> None:
    rendered = yaml.safe_dump(inventory, sort_keys=False)
    content = f"---\n{rendered}"

    if output_path == "-":
        sys.stdout.write(content)
        return

    path = Path(output_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def main() -> int:
    args = parse_args()

    if args.from_file:
        inventory = load_inventory_from_file(args.from_file)
    else:
        inventory = load_inventory_from_terraform(args.terraform_dir)

    validate_inventory_shape(inventory)
    dump_inventory(inventory, args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
