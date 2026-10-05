#!/usr/bin/env python3
# iOSの回帰テスト実行。インストール済みSimulatorを選び、同じ手順をCIでも使用する。
import argparse
import json
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--language-mode", choices=("5", "6"), default="5")
    parser.add_argument("--derived-data", default="/tmp/YoutubeKitTests")
    parser.add_argument("--deployment-target", help="検証ビルドだけの最低OS上書き")
    args = parser.parse_args()
    root = Path(__file__).resolve().parent.parent
    devices = json.loads(subprocess.check_output(
        ["xcrun", "simctl", "list", "devices", "available", "-j"], text=True
    ))["devices"]
    candidates = [
        (tuple(map(int, runtime.split(".iOS-")[-1].split("-"))), device["udid"])
        for runtime, entries in devices.items() if ".iOS-" in runtime
        for device in entries if device["name"].startswith("iPhone")
    ]
    if not candidates:
        parser.error("利用できるiPhone Simulatorがありません")
    _, device_id = max(candidates)
    for scheme in ("YoutubeKit", "YoutubeKit-Example"):
        # Exampleから見た依存パッケージのスキームにはテストが含まれない。
        project = [] if scheme == "YoutubeKit" else ["-project", "Example/YoutubeKit.xcodeproj"]
        command = [
            "xcodebuild", *project,
            "-scheme", scheme, "-configuration", "Debug",
            "-destination", f"platform=iOS Simulator,id={device_id}",
            "-derivedDataPath", str(Path(args.derived_data) / scheme),
            "-parallel-testing-enabled", "NO",
            "CODE_SIGNING_ALLOWED=NO", f"SWIFT_VERSION={args.language_mode}",
        ]
        if args.deployment_target:
            command.append(f"IPHONEOS_DEPLOYMENT_TARGET={args.deployment_target}")
        subprocess.run(command + ["test"], cwd=root, check=True)


if __name__ == "__main__":
    main()
