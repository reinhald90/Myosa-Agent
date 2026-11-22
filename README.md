# Myosa-Agent

**MYOSACODE AGENT** adalah AI coding agent untuk terminal Linux. Satu file Python, berjalan di VPS lewat SSH (Termius, dll.), dengan tampilan piksel, dua engine, pelindung VPS bawaan, dan persetujuan pengguna di setiap langkah yang berisiko.

> Versi: **3.0.0** · Bahasa: Indonesia · Lisensi: tentukan sendiri (mis. MIT)

---

## Kenapa Myosa Agent berbeda?

Banyak agent terminal sudah bisa membaca file dan menjalankan perintah. Yang membuat Myosa berbeda adalah **kombinasi** hal berikut dalam satu file kecil, bukan satu fitur tunggal:

| # | Pembeda | Penjelasan |
|---|---------|------------|
| 1 | **Persetujuan bertingkat** | Agent boleh mengerjakan apa pun, tapi bagian sensitif (rahasia, kirim data keluar, ubah sistem, hapus data, install dari internet) berhenti dan menampilkan menu: *Lanjut sekali / Lanjut & izinkan kategori / Lewati / Hentikan*. Ada juga `propose_plan` (rencana disetujui dulu) dan `ask_user` (agent bertanya, bukan menebak). |
| 2 | **Shield pelindung VPS** | `/shield` memberi skor keamanan 0-100, watcher latar belakang (brute force SSH, port baru, perubahan `passwd`, `authorized_keys`, `crontab`, `sudoers`), hardening 6 langkah yang disetujui satu per satu, dan blokir IP. |
| 3 | **Dua engine** | Engine **myosa** (API langsung, tool sendiri) dan engine **opencode** (meneruskan ke `opencode run`). Ganti dengan `/engine`. |
| 4 | **Auto-lanjut + status model** | Stream putus? Retry otomatis, lalu pindah ke model aktif lain. `/health` menandai model `●` aktif / `○` mati di menu `/model`. |
| 5 | **Shell menetap** | Tool `shell` mempertahankan `cd`, variabel, dan venv antar langkah. Pengguna bisa pakai `!perintah` atau `/sh` tanpa keluar dari agent. |
| 6 | **Aman secara default** | API key otomatis disamarkan di output tool, `/undo` untuk edit file, isi web/file diperlakukan sebagai *data* (bukan perintah), host SSH hanya yang terdaftar. |
| 7 | **UI piksel** | Logo kucing piksel (rata kiri, berkedip), 8 animasi intro logo, 8 animasi berpikir, menu navigasi panah. |
| 8 | **Prompt khusus DeepSeek** | System prompt berbahasa Indonesia yang disetel untuk function calling yang rapi. |

Catatan jujur: ini bukan klaim "satu-satunya di dunia". Sebagian fitur ada di agent lain. Nilai Myosa ada pada gabungan persetujuan + shield + failover + UI dalam satu file yang mudah dibaca dan dimodifikasi.

---

## Instalasi

Butuh Python 3.10+ (Ubuntu/Debian).

```bash
apt install -y python3-venv
python3 -m venv ~/myosa-env
~/myosa-env/bin/pip install -U openai rich pillow

git clone https://github.com/reinhald90/Myosa-Agent.git
cd Myosa-Agent
echo "alias myosa='~/myosa-env/bin/python ~/Myosa-Agent/myosa.py'" >> ~/.bashrc
source ~/.bashrc
myosa
```

Saat pertama dibuka, ketik `/key` lalu tempel API key (input tersembunyi). Key disimpan di `~/.myosa/config.json` dengan izin `600`.

Endpoint default adalah API kompatibel OpenAI. Ganti dengan variabel `ZURL` kalau perlu.

Sangat disarankan menjalankan di **tmux** supaya sesi dan watcher tidak mati saat koneksi putus:

```bash
tmux new -s myosa
myosa
```

---

## Perintah

| Perintah | Fungsi |
|----------|--------|
| `/help` | Daftar perintah |
| `/model` | Pilih model (menu panah, status aktif/mati) |
| `/health [kata]` | Cek model mana yang hidup |
| `/engine` | Pilih engine: myosa / opencode |
| `/mode` | `dev`, `ops`, `cyber` |
| `/shield` | Status, hardening, peringatan, blokir IP, watcher |
| `/audit [host]` | Audit keamanan read-only lalu laporan oleh agent |
| `/host` | Kelola server SSH terdaftar |
| `/guard on\|off\|reset` | Pengaman bagian sensitif |
| `/undo` | Batalkan edit file terakhir |
| `/anim`, `/logo` | Animasi berpikir dan animasi logo |
| `/key`, `/auto`, `/think`, `/save`, `/load`, `/clear`, `/exit` | Utilitas |
| `!perintah` | Jalankan shell langsung |
| `/sh` | Shell interaktif penuh |
| `@file.png` | Lampirkan gambar atau file di pesan |

---

## Mode

- **dev**: coding dan file.
- **ops**: administrasi server (instalasi, konfigurasi, monitoring).
- **cyber**: audit dan hardening **defensif** untuk server milik sendiri. Tidak ada exploit, brute force, atau pemindaian target pihak lain.

---

## Batasan (baca ini)

- **Guard bukan sandbox.** Deteksi bagian sensitif berbasis pola teks. Perintah yang disamarkan bisa lolos. Awasi sendiri di server penting.
- **Watcher hanya aktif selama Myosa terbuka.** Perlindungan permanen datang dari fail2ban dan ufw hasil `/shield harden`.
- Langkah **SSH key-only** bisa mengunci pengguna di luar VPS. Uji login key di sesi kedua sebelum menyetujui.
- Model kecil (mis. varian `flash`) kadang kurang rapi memanggil tool.
- Dirancang untuk Ubuntu/Debian. Belum diuji luas di distro lain.

---

## Berkas konfigurasi

```
~/.myosa/config.json   pengaturan + API key (izin 600)
~/.myosa/hosts.json    server SSH terdaftar
~/.myosa/health.json   status model
~/.myosa/shield.json   baseline Shield
~/.myosa/shield.log    log peringatan
~/.myosa/sessions/     sesi tersimpan
~/.myosa/undo/         cadangan untuk /undo
```

**Jangan pernah meng-commit folder `~/.myosa/`.** Isinya rahasia.

---

## Dokumen lain

- [`Agent.md`](Agent.md): identitas, kemampuan, dan cara kerja agent.
- [`Rules.md`](Rules.md): aturan wajib untuk agent, pengguna, dan kontributor.

---

Dibuat oleh **reinhald90** (Azure Tech).
