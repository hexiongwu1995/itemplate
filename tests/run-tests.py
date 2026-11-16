#!/usr/bin/env python3
"""Smoke tests for the itemplate Typst package.

Run from any directory with the repository root available:

    python3 tests/run-tests.py

Set TYPST=/path/to/typst to test a specific compiler.
Generated HTML is written to tests/output/ for manual inspection.
"""

from __future__ import annotations

import html as html_lib
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "tests" / "fixtures"
OUTPUT = ROOT / "tests" / "output"
TYPST = os.environ.get("TYPST") or shutil.which("typst") or "typst"

FAILURES: list[str] = []
CHECKS = 0


def check(name: str, condition: bool, detail: str = "") -> None:
    global CHECKS
    CHECKS += 1
    if condition:
        print(f"PASS  {name}")
    else:
        message = f"FAIL  {name}" + (f"\n      {detail}" if detail else "")
        print(message)
        FAILURES.append(name)


def compile_doc(source: Path, output_name: str) -> str:
    OUTPUT.mkdir(parents=True, exist_ok=True)
    destination = OUTPUT / f"{output_name}.html"
    result = subprocess.run(
        [
            TYPST,
            "compile",
            "--root",
            str(ROOT),
            "--features",
            "html",
            "--format",
            "html",
            str(source),
            str(destination),
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"typst failed for {source.name}:\n{result.stdout}\n{result.stderr}"
        )
    return destination.read_text(encoding="utf-8")


def compile_fixture(name: str) -> str:
    return compile_doc(FIXTURES / f"{name}.typ", name)


def span_text(html: str, class_name: str) -> list[str]:
    values = re.findall(
        rf'<span class="{re.escape(class_name)}">(.*?)</span>', html, re.S
    )
    return [
        html_lib.unescape(re.sub(r"<[^>]+>", "", value)).strip() for value in values
    ]


def toc_section(html: str) -> str:
    match = re.search(r'<nav class="toc-nav".*?</nav>', html, re.S)
    if not match:
        raise AssertionError("TOC nav not found")
    return match.group(0)


def import_map(html: str) -> str | None:
    match = re.search(r'<script type="importmap">(.*?)</script>', html, re.S)
    return match.group(1) if match else None


def css_block(html: str, selector: str) -> str:
    match = re.search(
        re.escape(selector) + r"\s*\{(.*?)\}", html, re.S
    )
    if not match:
        raise AssertionError(f"CSS block not found: {selector}")
    return match.group(1)


def test_toc_levels() -> None:
    html = compile_fixture("toc-levels")
    toc = toc_section(html)
    check("toc-levels keeps every heading", span_text(toc, "toc-text") == ["A", "C", "B", "D"], span_text(toc, "toc-text"))
    ids = re.findall(r'id="(sec-[^"]+)"', html)
    check("toc-levels anchors are unique", len(ids) == len(set(ids)), str(ids))
    links = re.findall(r'href="#(sec-[^"]+)"', toc)
    check(
        "toc-levels links resolve to headings",
        links == ids,
        f"links={links} ids={ids}",
    )


def test_toc_deep_start() -> None:
    html = compile_fixture("toc-levels-deep-start")
    check(
        "toc-levels-deep-start keeps h2 before h1",
        span_text(toc_section(html), "toc-text") == ["B", "A"],
        span_text(toc_section(html), "toc-text"),
    )


def test_toc_nested_levels() -> None:
    html = compile_fixture("toc-levels-nested")
    check(
        "toc-levels-nested keeps headings after a skipped level",
        span_text(toc_section(html), "toc-text") == ["A", "B", "D", "C", "E"],
        span_text(toc_section(html), "toc-text"),
    )


def test_toc_numbering() -> None:
    html = compile_fixture("toc-numbering")
    toc_numbers = span_text(toc_section(html), "toc-num")
    heading_numbers = span_text(html, "h-num")
    check(
        "document heading numbering wins",
        heading_numbers == ["1", "1.a", "1.a.a"],
        str(heading_numbers),
    )
    check(
        "toc uses the document numbering format",
        toc_numbers == heading_numbers,
        f"toc={toc_numbers} headings={heading_numbers}",
    )


def test_heading_numbering_param() -> None:
    html = compile_fixture("heading-numbering-param")
    toc_numbers = span_text(toc_section(html), "toc-num")
    heading_numbers = span_text(html, "h-num")
    check(
        "heading-numbering parameter is applied",
        heading_numbers == ["1", "1.1"],
        str(heading_numbers),
    )
    check(
        "toc follows heading-numbering parameter",
        toc_numbers == heading_numbers,
        f"toc={toc_numbers} headings={heading_numbers}",
    )


def test_heading_numbering_disabled() -> None:
    html = compile_fixture("heading-numbering-none")
    check(
        "heading numbering can be hidden",
        span_text(html, "h-num") == [] and span_text(toc_section(html), "toc-num") == [],
        f"headings={span_text(html, 'h-num')} toc={span_text(toc_section(html), 'toc-num')}",
    )
    check(
        "hidden numbering still keeps TOC entries",
        span_text(toc_section(html), "toc-text") == ["One", "Two"],
        span_text(toc_section(html), "toc-text"),
    )
    ids = re.findall(r'id="(sec-[^"]+)"', html)
    check("hidden numbering keeps unique anchors", len(ids) == len(set(ids)), str(ids))


def test_i18n() -> None:
    english = compile_fixture("i18n-en")
    check("English TOC label", "CONTENTS" in english)
    check("English TOC toggle label", "Expand subsection" in english)
    check("English skip link", "Skip to content" in english)
    check("English sidebar label", "Document contents" in english)
    check("English table label", "Table, horizontally scrollable" in english)
    check("English theme label", "Toggle theme" in english)
    chinese_labels = ["展开子目录", "暂无目录", "跳到正文", "文档目录", "关闭目录", "调整目录宽度"]
    leaked = [label for label in chinese_labels if label in english]
    check("English UI has no hard-coded Chinese labels", not leaked, str(leaked))

    chinese = compile_fixture("i18n-zh")
    for label in ["目录", "展开子目录", "跳到正文", "文档目录", "表格，可横向滚动", "切换主题"]:
        check(f"Chinese UI contains {label}", label in chinese)


def test_theme_merge() -> None:
    html = compile_fixture("theme-merge")
    light = css_block(html, ":root")
    green = css_block(html, ":root[data-theme='green']")
    dark = css_block(html, ":root[data-theme='dark']")
    check("light theme keeps custom accent", "--accent: #123456;" in light)
    check("green theme inherits custom theme overrides", "--accent: #123456;" in green)
    check("dark theme keeps its own accent", "--accent: #d97757;" in dark)
    check(
        "theme toggle order is light, green, dark",
        'const themeOrder = ["light", "green", "dark"];' in html,
    )


def test_import_maps() -> None:
    default_map = import_map(compile_fixture("import-map-default"))
    check("default import map is emitted", default_map is not None)
    if default_map:
        parsed_map = json.loads(default_map)
        check("default import map is valid JSON", "imports" in parsed_map)
        for key in ["three", "three/addons/", "echarts", "echarts-gl", "plotly", "cannon-es"]:
            check(f"default import map has {key}", key in parsed_map.get("imports", {}))

    custom_map = import_map(compile_fixture("import-map-custom"))
    check("custom import map is emitted", custom_map is not None)
    if custom_map:
        parsed_custom = json.loads(custom_map)["imports"]
        check("custom import map keeps defaults", "three" in parsed_custom)
        check("custom import map can be extended", "d3" in parsed_custom)

    disabled = compile_fixture("import-map-disabled")
    check("import map can be disabled", import_map(disabled) is None)


def test_client_script() -> None:
    html = compile_fixture("i18n-en")
    match = re.search(r"const ui = (\{.*?\});\s*\nconst mq", html, re.S)
    check("client UI strings are embedded", match is not None)
    if match:
        ui = json.loads(match.group(1))
        check(
            "client UI strings are complete",
            set(ui) == {
                "themeLight",
                "themeGreen",
                "themeDark",
                "themeCurrent",
                "tocExpand",
                "tocCollapse",
                "sidebarExpand",
                "sidebarCollapse",
            },
            str(ui),
        )

    module = re.search(r'<script type="module">(.*?)</script>', html, re.S)
    check("module script is emitted", module is not None)
    node = shutil.which("node")
    if module and node:
        script_path = OUTPUT / "client-script.mjs"
        script_path.write_text(module.group(1), encoding="utf-8")
        result = subprocess.run(
            [node, "--check", str(script_path)],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        check("client script is valid JavaScript", result.returncode == 0, result.stderr)
    elif not node:
        print("SKIP  node not found; client script syntax not checked")


def test_existing_demos() -> None:
    for name in ["test", "test1"]:
        html = compile_doc(ROOT / f"{name}.typ", name)
        check(f"{name}.typ compiles", bool(html))
        if name == "test":
            toc_numbers = span_text(toc_section(html), "toc-num")
            heading_numbers = span_text(html, "h-num")
            check(
                "demo TOC numbers match headings",
                toc_numbers == heading_numbers,
                f"toc={toc_numbers} headings={heading_numbers}",
            )


def test_package_file_list() -> None:
    list_path = ROOT / "tests" / "package-files.txt"
    entries = [
        line.strip()
        for line in list_path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    check("package file list is not empty", bool(entries))
    for entry in entries:
        check(f"package file exists: {entry}", (ROOT / entry).exists())

    workflow = (ROOT / ".github" / "workflows" / "publish-to-fork.yml").read_text(
        encoding="utf-8"
    )
    try:
        copy_block = workflow.split("cp -rv \\", 1)[1].split('"${DEST}/"', 1)[0]
        workflow_entries = [
            line.strip().rstrip("\\").strip()
            for line in copy_block.splitlines()
            if line.strip()
        ]
    except IndexError:
        workflow_entries = []
    check(
        "publish workflow uses the same package file list",
        workflow_entries == entries,
        f"workflow={workflow_entries} list={entries}",
    )

    forbidden = ["test.typ", "test1.typ", "tests", ".github", "git-tutorial.md"]
    leaked = [item for item in forbidden if item in entries]
    check("dev/test files are excluded from the package", not leaked, str(leaked))


def main() -> int:
    print(f"Using typst: {TYPST}")
    version = subprocess.run([TYPST, "--version"], capture_output=True, text=True)
    print(version.stdout.strip() or version.stderr.strip())

    tests = [
        test_toc_levels,
        test_toc_deep_start,
        test_toc_nested_levels,
        test_toc_numbering,
        test_heading_numbering_param,
        test_heading_numbering_disabled,
        test_i18n,
        test_theme_merge,
        test_import_maps,
        test_client_script,
        test_existing_demos,
        test_package_file_list,
    ]
    for test in tests:
        print(f"\n--- {test.__name__}")
        try:
            test()
        except Exception as error:  # noqa: BLE001 - report and continue
            check(test.__name__, False, str(error))

    print(f"\n{CHECKS - len(FAILURES)}/{CHECKS} checks passed")
    if FAILURES:
        print("Failed checks:")
        for failure in FAILURES:
            print(f"  - {failure}")
        return 1
    print("All smoke tests passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
