"""Peluncur MYOSACODE AGENT untuk instalasi lewat pip / pipx / install.sh.

Perintah `myosa` memanggil run(). Bendera --version, --help, dan --update ditangani di sini
(tanpa memuat openai/rich). Selain itu, myosa.py dijalankan persis seperti `python myosa.py`.
"""
import importlib.util
import os
import runpy
import subprocess
import sys

PKG = "myosa-agent"
GIT_SOURCE = "git+https://github.com/reinhald90/Myosa-Agent.git"

HELP = """MYOSACODE AGENT

pakai:
  myosa              jalankan agent
  myosa --version    tampilkan versi
  myosa --update     perbarui ke versi terbaru dari GitHub
  myosa --help       bantuan ini

Perintah di dalam agent: ketik /help
Dokumen: https://github.com/reinhald90/Myosa-Agent"""


def _version():
    try:
        from importlib.metadata import version
        return version(PKG)
    except Exception:
        return "tidak diketahui (dijalankan dari source)"


def _update():
    src = os.environ.get("MYOSA_SOURCE") or GIT_SOURCE
    cmd = [sys.executable, "-m", "pip", "install", "-U", src]
    print("memperbarui dari:", src)
    try:
        rc = subprocess.call(cmd)
    except OSError as e:
        print("gagal menjalankan pip:", e)
        rc = 1
    if rc != 0:
        print("\nPembaruan gagal. Coba salah satu:\n"
              "  pipx upgrade %s        (jika dipasang lewat pipx)\n"
              "  curl -fsSL https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/install.sh | bash\n"
              "Pastikan git terpasang (apt install -y git)." % PKG)
    else:
        print("selesai. Jalankan `myosa --version` untuk memeriksa.")
    return rc


def run():
    args = sys.argv[1:]
    if args and args[0] in ("-V", "--version", "version"):
        print("MYOSACODE AGENT", _version())
        return 0
    if args and args[0] in ("-h", "--help", "help"):
        print(HELP)
        return 0
    if args and args[0] in ("--update", "update"):
        sys.exit(_update())
    if sys.version_info < (3, 10):
        print("Myosa butuh Python 3.10 atau lebih baru (yang dipakai: %d.%d)." % sys.version_info[:2])
        sys.exit(1)
    missing = [m for m in ("openai", "rich") if importlib.util.find_spec(m) is None]
    if missing:
        print("Modul belum terpasang: %s\nPerbaiki dengan: myosa --update  (atau jalankan ulang install.sh)" % ", ".join(missing))
        sys.exit(1)
    runpy.run_module("myosa", run_name="__main__")
    return 0


if __name__ == "__main__":
    run()
