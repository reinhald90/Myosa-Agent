#!/usr/bin/env bash
# Pemasang MYOSACODE AGENT (tanpa root, tidak menyentuh Python sistem)
#
#   curl -fsSL https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/install.sh | bash
#
# Perbarui : jalankan perintah yang sama lagi, atau `myosa --update`
# Hapus    : curl -fsSL .../install.sh | bash -s -- --uninstall
#
# Opsi lingkungan (semua opsional):
#   MYOSA_SOURCE=...        sumber paket (default: git+https://github.com/reinhald90/Myosa-Agent.git)
#   MYOSA_VENV=...          lokasi venv (default: ~/.local/share/myosa/venv)
#   MYOSA_BIN=...           lokasi perintah `myosa` (default: ~/.local/bin)
#   MYOSA_PIP_ARGS="..."    argumen tambahan untuk pip (mis. --index-url ...)
#   MYOSA_NO_MODIFY_PATH=1  jangan ubah ~/.bashrc / ~/.zshrc
set -euo pipefail

SOURCE="${MYOSA_SOURCE:-git+https://github.com/reinhald90/Myosa-Agent.git}"
VENV="${MYOSA_VENV:-${XDG_DATA_HOME:-$HOME/.local/share}/myosa/venv}"
BIN="${MYOSA_BIN:-$HOME/.local/bin}"
PIP_ARGS="${MYOSA_PIP_ARGS:-}"
MARK="# myosa-agent (PATH)"

say()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[1;31mGAGAL:\033[0m %s\n' "$*" >&2; exit 1; }

if [ "${1:-}" = "--uninstall" ]; then
  rm -rf "$VENV"
  [ -L "$BIN/myosa" ] && rm -f "$BIN/myosa"
  say "Myosa dihapus. Konfigurasi dan API key di ~/.myosa TIDAK dihapus (hapus manual jika mau)."
  exit 0
fi

case "$(uname -s)" in
  Linux|Darwin) ;;
  *) die "sistem operasi tidak didukung (butuh Linux atau macOS)";;
esac

# 1. Python >= 3.10
PY=""
for c in python3.13 python3.12 python3.11 python3.10 python3 python; do
  if command -v "$c" >/dev/null 2>&1 && "$c" -c 'import sys; sys.exit(sys.version_info < (3, 10))' 2>/dev/null; then
    PY="$c"; break
  fi
done
[ -n "$PY" ] || die "butuh Python 3.10+. Ubuntu/Debian: apt install -y python3 python3-venv"
say "Python: $($PY --version 2>&1)"

# 2. git (hanya jika sumbernya git)
case "$SOURCE" in
  git+*) command -v git >/dev/null 2>&1 || die "git belum terpasang. Ubuntu/Debian: apt install -y git";;
esac

# 3. venv
if [ ! -x "$VENV/bin/python" ]; then
  say "Membuat venv di $VENV"
  mkdir -p "$(dirname "$VENV")"
  "$PY" -m venv "$VENV" || { rm -rf "$VENV"; die "gagal membuat venv. Ubuntu/Debian: apt install -y python3-venv"; }
fi

# 4. pasang
say "Memasang Myosa (butuh internet)"
"$VENV/bin/python" -m pip install -q -U pip >/dev/null 2>&1 || warn "pip tidak diperbarui (dilewati)"
# shellcheck disable=SC2086
"$VENV/bin/python" -m pip install -U $PIP_ARGS "$SOURCE" || die "pemasangan gagal. Periksa koneksi, atau pasang git."
# shellcheck disable=SC2086
"$VENV/bin/python" -m pip install -q -U $PIP_ARGS pillow >/dev/null 2>&1 || warn "pillow tidak terpasang (fitur gambar nonaktif, sisanya normal)"

# 5. perintah `myosa`
mkdir -p "$BIN"
ln -sf "$VENV/bin/myosa" "$BIN/myosa"

# 6. PATH
case ":$PATH:" in
  *":$BIN:"*) ;;
  *)
    if [ "${MYOSA_NO_MODIFY_PATH:-0}" != "1" ]; then
      for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$rc" ] && ! grep -qF "$MARK" "$rc"; then
          printf '\n%s\nexport PATH="%s:$PATH"\n' "$MARK" "$BIN" >> "$rc"
          say "PATH ditambahkan ke $rc"
        fi
      done
    fi
    warn "buka sesi baru, atau jalankan: export PATH=\"$BIN:\$PATH\""
    ;;
esac

say "$("$VENV/bin/myosa" --version)"
printf '\nSelesai. Jalankan:\n  tmux new -s myosa\n  myosa\n\nDi dalam Myosa: /key (API key), /provider, /help\n'
