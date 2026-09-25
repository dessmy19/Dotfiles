#!/usr/bin/env python3
import os
import subprocess
import sys

CONFIG_DIR = os.path.dirname(os.path.abspath(__file__))

def select(prompt, multiple=False, directory=False):
    start_dir = os.path.expanduser("~")
    cmd = [
        "fzf",
        "--prompt", f" {prompt}> ",
        "--height=60%",
        "--layout=reverse",
        "--border=none",
        "--no-separator",
        "--no-scrollbar",
        "--pointer", "  ",
        "--marker", "  ",
        "--preview", f"{CONFIG_DIR}/preview.py {{}} $FZF_PREVIEW_COLUMNS $FZF_PREVIEW_LINES",
        "--preview-window", "right,65%,wrap,border-none",
        "--color", "bg+:#7aa2f7,spinner:#7aa2f7,hl:#7dcfff,fg:#c0caf5,header:#7aa2f7,info:#9ece6a,pointer:#bb9af7,marker:#bb9af7,fg+:#1a1b26,prompt:#7aa2f7,hl+:#e0af68,gutter:#1a1b26",
    ]
    if multiple:
        cmd.append("--multi")
        cmd.append("--bind=space:toggle+down")
    if directory:
        find_cmd = ["find", start_dir, "-type", "d", "-not", "-path", "*/.git/*", "-printf", "%p\n"]
    else:
        find_cmd = ["find", start_dir, "-type", "f", "-not", "-path", "*/.git/*", "-printf", "%p\n"]
    find_proc = subprocess.run(find_cmd, capture_output=True, text=True)
    fzf_proc = subprocess.run(cmd, input=find_proc.stdout, capture_output=True, text=True)
    if fzf_proc.returncode == 0:
        return fzf_proc.stdout.strip().split("\n")
    return []

if __name__ == "__main__":
    prompt = sys.argv[1] if len(sys.argv) > 1 else "File"
    multiple = "--multi" in sys.argv
    directory = "--directory" in sys.argv
    sel = select(prompt, multiple, directory)
    if sel:
        print("\n".join(sel))
