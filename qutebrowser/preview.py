#!/usr/bin/env python3
import os
import subprocess
import sys

def preview(file, width, height):
    if not os.path.exists(file):
        return ""
    if os.path.isdir(file):
        return subprocess.run(["ls", "-la", "--color=always", file], capture_output=True, text=True).stdout
    mime = subprocess.run(["file", "--mime-type", "-b", file], capture_output=True, text=True).stdout.strip()
    if mime.startswith("image/"):
        out = subprocess.run(["chafa", "-f", "sixel", "-s", f"{width}x{height}", file], capture_output=True, text=True).stdout
        if out:
            return out
        return subprocess.run(["chafa", "-s", f"{width}x{height}", file], capture_output=True, text=True).stdout
    if mime.startswith("video/"):
        thumb = f"/tmp/thumb-{os.path.basename(file)}.jpg"
        subprocess.run(["ffmpegthumbnailer", "-i", file, "-o", thumb, "-s", "0", "-q", "10"], capture_output=True)
        if os.path.exists(thumb):
            return preview(thumb, width, height)
    if mime == "application/pdf":
        return "\n".join(subprocess.run(["mutool", "draw", "-F", "txt", "-o", "-", file, "1"], capture_output=True, text=True).stdout.split("\n")[:height])
    if mime in ("application/zip", "application/x-tar", "application/gzip", "application/x-bzip2", "application/x-xz") or (mime.startswith("application/") and "compress" in mime):
        return "\n".join(subprocess.run(["tar", "-tvf", file], capture_output=True, text=True).stdout.split("\n")[:height])
    if mime.startswith("text/") or mime in ("application/json", "application/xml", "application/javascript", "application/x-shellscript"):
        return "\n".join(subprocess.run(["cat", file], capture_output=True, text=True).stdout.split("\n")[:height])
    return subprocess.run(["file", file], capture_output=True, text=True).stdout

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        file = sys.argv[1]
        width = int(sys.argv[2]) if len(sys.argv) > 2 else 80
        height = int(sys.argv[3]) if len(sys.argv) > 3 else 40
        printpreview(file, width, height))