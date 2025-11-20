# -*- coding: utf-8 -*-
#
# Licensed under the terms of the BSD 3-Clause
# (see datalab/LICENSE for details)

"""Make a WiX Toolset .wxs file for the DataLab Windows installer.

History:

- Version 1.0.0 (2024-04-01)
    Initial version.
"""

# TODO: Localization, eventually.

import argparse
import os
import os.path as osp

COUNT = 0


def generate_id() -> str:
    """Generate an ID for a WiX Toolset XML element."""
    global COUNT
    COUNT += 1
    return f"ID_{COUNT:04d}"


def insert_text_after(text: str, containing: str, content: str) -> str:
    """Insert line of text after the line containing a specific text."""
    if os.linesep in content:
        linesep = os.linesep
    elif "\r\n" in content:
        linesep = "\r\n"
    else:
        linesep = "\n"
    lines = content.splitlines()
    for i_line, line in enumerate(lines):
        if containing in line:
            lines.insert(i_line + 1, text)
            break
    return linesep.join(lines)


def make_wxs(product_name: str, version: str) -> None:
    """Make a .wxs file for the DataLab Windows installer."""
    wix_dir = osp.abspath(osp.dirname(__file__))
    proj_dir = osp.abspath(osp.join(wix_dir, os.pardir))
    dist_dir = osp.join(proj_dir, "dist", product_name)
    archive_path = osp.join(proj_dir, "dist", f"{product_name}-files.zip")
    wxs_path = osp.join(wix_dir, f"generic-{product_name}.wxs")
    output_path = osp.join(wix_dir, f"{product_name}-{version}.wxs")

    # Check if archive exists
    if not osp.exists(archive_path):
        print(f"ERROR: Archive not found at: {archive_path}")
        print(f"Working directory: {os.getcwd()}")
        print(f"Project directory: {proj_dir}")
        raise FileNotFoundError(f"Archive not found: {archive_path}")

    # Get archive size for statistics
    archive_size_mb = osp.getsize(archive_path) / (1024 * 1024)

    # Count files in dist directory for statistics
    total_files = sum(len(files) for _, _, files in os.walk(dist_dir))

    print("Archive-based installer mode:")
    print(f"  Archive: {osp.basename(archive_path)}")
    print(f"  Archive size: {archive_size_mb:.1f} MB")
    print(f"  Total files archived: {total_files}")
    print("  Components in MSI: ~15 (executables + archive + cleanup)")

    # Create the .wxs file:
    with open(wxs_path, "r", encoding="utf-8") as fd:
        wxs = fd.read()

    # Replace version placeholder
    wxs = wxs.replace("{version}", version)
    wxs = wxs.replace("{archive_path}", f"dist\\{product_name}-files.zip")

    with open(output_path, "w", encoding="utf-8") as fd:
        fd.write(wxs)
    print("Successfully created:", output_path)


def run() -> None:
    """Run the script."""
    parser = argparse.ArgumentParser(
        description="Make a WiX Toolset .wxs file for the DataLab Windows installer."
    )
    parser.add_argument("product_name", help="Product name")
    parser.add_argument("version", help="Product version")
    args = parser.parse_args()
    make_wxs(args.product_name, args.version)


if __name__ == "__main__":
    if len(os.sys.argv) == 1:
        # For testing purposes:
        make_wxs("DataLab-WinPython", "0.14.2")
    else:
        run()

    # After making the .wxs file, run the following command to create the .msi file:
    #   wix build .\wix\DataLab.wxs -ext WixToolset.UI.wixext
