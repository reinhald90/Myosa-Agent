<div align="center">

<img src="https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/banner.png" alt="MYOSACODE AGENT" width="100%">

<br>

**AI coding agent untuk terminal Linux, dengan pelindung VPS bawaan dan persetujuan di setiap langkah berisiko.**

*Satu file Python. Khusus **Ubuntu dan Debian**, dijalankan di VPS lewat SSH (mis. Termius). Tampilan piksel.*

<br>

![versi](https://img.shields.io/badge/versi-5.9.0-a06bff?style=for-the-badge)
![python](https://img.shields.io/badge/python-3.10%2B-00b8ff?style=for-the-badge&logo=python&logoColor=white)
![platform](https://img.shields.io/badge/Ubuntu%20%2F%20Debian-00ffd5?style=for-the-badge&logo=ubuntu&logoColor=black)
![lisensi](https://img.shields.io/badge/lisensi-MIT-6a8cff?style=for-the-badge)

[Fitur](#-fitur-unggulan) · [Kenapa berbeda](#-kenapa-myosa-berbeda) · [Instalasi](#-instalasi) · [Provider](#-provider-api) · [Shield](#-myosa-shield) · [Izin](#-tingkat-izin-l0-l3) · [GitHub](#-github-login-seperti-codex) · [Perintah](#-perintah) · [Batasan](#-batasan-baca-ini)

</div>

---

## ✨ Fitur unggulan

| | |
|---|---|
| 🛡️ **Myosa Shield** | Pelindung VPS aktif: deteksi brute force dan port scan, blokir lewat **fail2ban + firewall (ufw)**, skor keamanan 0-100, hardening yang disetujui per langkah. |
| ✋ **Persetujuan bertingkat** | Agent boleh mengerjakan apa pun, **tapi bagian sensitif selalu berhenti** dan menunggu pilihanmu: *Lanjut sekali / Lanjut & izinkan / Lewati / Hentikan*. |
| 🧠 **Berpikir dalam** | Tiga level (`normal`, `dalam`, `ekstrem`) dengan rencana, antisipasi gagal, dan **verifikasi mandiri** sebelum menyatakan selesai. |
| 🖥️ **Tampilan ala komputer** | Pikiran mengalir real time, kode yang sedang ditulis tampil live dengan syntax highlight, 8 animasi berpikir, dan animasi boot dengan titik yang berubah tiap detik. |
| 🐱 **Myosa hidup** | Maskot kucing piksel yang berkedip real time, menyapa, memberi tips saat kamu diam, dan memandu saat kamu bingung. |
| 🔌 **Multi-provider** | Satu agent, banyak penyedia API kompatibel OpenAI. API key tersimpan di `~/.myosa/.env.local`. |
| ⚙️ **Dua engine** | Engine **myosa** (API langsung) atau engine **opencode** (meneruskan ke `opencode run`). |
| 🧩 **Plugin dan `/evolve`** | Minta fitur baru, Myosa menulisnya sebagai plugin terpisah. Inti tidak tersentuh. |
| 🔐 **Tingkat izin L0-L3** | Kamu yang menentukan seberapa jauh agent boleh bertindak: hanya baca, normal, otonom, sampai kontrol penuh VPS. Selalu mulai di L1. |
| 🤖 **Mode otonom** | `/otonom` mengerjakan tugas panjang sendiri dengan batas langkah dan waktu. Bagian sensitif tetap berhenti dan bertanya. |
| 👥 **Agen paralel** | Sampai 4 sub-agen (hanya baca) menyelidiki hal berbeda sekaligus, lalu hasilnya digabung. |
| 🐙 **Login GitHub** | `/gh login` seperti `codex login`: kode, klik Authorize, selesai. Issue, branch, dan PR atas nama akunmu. Tidak pernah menulis ke `main`. |
| 🧰 **Alat server** | `system_info`, `port_list`, `top_procs`, `git_status`, `find_files`, `calc`, `hash_file`, `service_status`, `log_tail`, `docker_ps`, dan catatan lintas sesi. |
| 🎯 **Enam mode kerja** | `dev`, `eng`, `ops`, `cyber`, `data`, `riset`. Prompt disusun agar bekerja di semua model AI, bukan satu model saja. |

---

## 🆚 Kenapa Myosa berbeda?

Banyak agent terminal sudah bisa membaca file dan menjalankan perintah. Yang membuat Myosa berbeda adalah **kombinasi** hal berikut dalam satu file yang mudah dibaca dan dimodifikasi:

1. **Agent yang menjaga servernya sendiri.** Shield bekerja bareng fail2ban dan firewall, lengkap dengan pengaman supaya kamu tidak terkunci dari VPS-mu.
2. **Persetujuan, bukan sekadar izin.** Rahasia, kirim data keluar, ubah sistem, hapus data, dan install dari internet selalu butuh keputusanmu, bahkan saat mode `AUTO`.
3. **Tahan gangguan.** Stream putus? Retry otomatis, lalu pindah ke model aktif lain. `/health` menandai model `●` aktif dan `○` mati.
4. **Aman terhadap dirinya sendiri.** Inti `myosa.py` dilindungi, ada backup otomatis, `/rollback`, `/undo`, dan penyamaran API key di output tool.
5. **Terasa hidup.** UI piksel, animasi, dan maskot yang bereaksi, bukan sekadar teks yang lewat.

> Catatan jujur: ini bukan klaim "satu-satunya di dunia". Sebagian fitur ada di agent lain. Nilai Myosa ada pada gabungannya.

---

## 🛡️ Myosa Shield

Shield berjalan di latar belakang selama Myosa terbuka dan bekerja sama dengan fail2ban dan firewall.

| Level | Perilaku |
|-------|----------|
| `pasif` | Hanya memberi peringatan, tidak memblokir apa pun. |
| `waspada` | Blokir otomatis jika skor brute force ≥ 15 per 10 menit atau scan ≥ 25 port. Menyalakan ulang fail2ban jika mati. |
| `agresif` *(bawaan)* | Blokir di skor ≥ 8 atau scan ≥ 12 port. Pelanggar berulang masuk **firewall** dengan durasi 7 kali lebih lama. fail2ban dan ufw dinyalakan ulang otomatis jika mati. |

**Yang dipantau:** brute force SSH, port scan, login berhasil setelah banyak gagal, akun UID 0 asing, port baru terbuka, dan perubahan `sshd_config`, `cron`, `sudoers`, `authorized_keys`.

**Pengaman supaya kamu tidak terkunci:**
- IP whitelist, **semua koneksi SSH yang sedang aktif**, IP server sendiri, dan jaringan privat **tidak pernah diblokir**.
- Blokir otomatis dibatasi 40 per jam dan kedaluwarsa otomatis.
- Yang diblokir adalah **IP tunggal**, bukan seluruh ASN atau rentang besar.

```text
/shield            menu Shield
/shield status     skor keamanan dan kondisi pertahanan
/shield harden     perkuat VPS (kamu setujui tiap langkah)
/shield level      pilih pasif / waspada / agresif
/shield allow      whitelist IP (anti-terkunci)
/shield bans       IP yang sedang diblokir
/shield ban IP     blokir manual   (/shield unban IP untuk membuka)
```

**Urutan aktivasi yang disarankan:**

```bash
tmux new -s myosa
myosa
/shield allow      # daftarkan IP-mu dulu
/shield harden     # fail2ban agresif, log firewall, ufw limit
/shield level      # pilih level respons
```

---

## 🔐 Tingkat izin (L0-L3)

Ubah dengan `/izin`. **Setiap Myosa dibuka, izin kembali ke L1.** Level tinggi tidak disimpan antar sesi.

| Level | Nama | Perilaku |
|-------|------|----------|
| **L0** | BACA | Hanya membaca. Menolak semua perintah yang mengubah sesuatu. |
| **L1** | NORMAL *(bawaan)* | Tanya sebelum perintah yang tidak aman. |
| **L2** | OTONOM | Kerja otomatis. Bagian sensitif dan plugin **tetap tanya**. |
| **L3** | PENUH | L2 + kontrol VPS: `service_ctl`, `pkg_manage`, `docker_ctl`, `ufw_rule`. Naik ke L3 harus mengetik `PENUH`. |

**Batas keras di semua level** (tidak bisa dibuka lewat izin): menghapus root/home/folder sistem, `mkfs`, `dd` ke disk, reboot/shutdown, menghentikan SSH/fail2ban/ufw/jaringan, mengosongkan iptables, menghapus user, dan mengutak-atik log.

```text
/izin                 pilih tingkat izin (menu)
/otonom [-l langkah] [-m menit] <tugas>
                      mode otonom dengan batas langkah dan waktu
                      contoh: /otonom -l 30 -m 15 audit keamanan server ini dan buat laporan
```

**Agen paralel:** agent bisa memanggil sampai 4 sub-agen sekaligus (maks 8 langkah dan 150 detik tiap agen, hanya alat baca). Ini mempercepat penyelidikan, tetapi **memperbanyak panggilan API**.

> Catatan jujur: batas keras dan daftar perintah baca-saja di L0 berbasis pola teks, bukan sandbox. Perintah yang disamarkan bisa lolos.

---

## 🐙 GitHub: login seperti Codex

Myosa bisa membuat issue, commit ke branch, dan membuka pull request. Tidak perlu token manual:

```text
/gh login        tampil kode, buka github.com/login/device, klik Authorize
/gh repo         pilih repo (otomatis dari git remote jika di folder repo)
/gh status       akun dan repo aktif
/gh id           atur identitas commit git ke akunmu
/gh push [nama]  kirim commit ke BRANCH baru (bukan main)
/gh pr <branch> <judul>
/gh logout       hapus token lokal
```

- Aksi dilakukan **atas nama akunmu**, hanya di repo yang sudah dipasangi [GitHub App Myosa Agent](https://github.com/apps/myosa-agent).
- Agent **tidak pernah menulis ke branch utama**. Ia bekerja di branch, membuat PR, dan **kamu yang merge**.
- Semua aksi tulis (issue, komentar, commit, PR) minta persetujuan dan ditolak di L0.
- File rahasia (`.env`, kunci privat, token) ditolak sebelum terkirim. Path `.github/` dan `..` juga ditolak.
- Token pengguna disimpan di `~/.myosa/github-user.json` (izin 600) dan tidak pernah tampil di output. Cabut kapan saja di `github.com/settings/applications`.
- Pemilik proyek bisa memakai mode bot (`~/.myosa/github.json` + kunci App). Kunci itu **tidak pernah dibagikan** ke pengguna lain.

Aktifkan **branch protection** di `main` pada repomu sebagai lapisan pengaman kedua.

---

## 🚀 Instalasi

**Khusus Ubuntu dan Debian**, dijalankan di VPS lewat SSH (misalnya dari HP dengan **Termius**). Butuh Python 3.10+ dan git. Tidak perlu root untuk pemasangan.

> **Tidak didukung:** Termux/Android (native), Windows. Fitur Shield dan kontrol VPS butuh root, systemd, fail2ban, dan ufw. Dari Android, pakai Termius untuk masuk ke VPS-mu.

```bash
apt install -y python3 python3-venv git curl
```

**Cara 1: satu perintah (disarankan)**

```bash
curl -fsSL https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/install.sh | bash
```

Skrip ini membuat venv sendiri, memasang Myosa, lalu membuat perintah `myosa`. Python sistem tidak disentuh. Baca dulu skripnya kalau mau: [`install.sh`](install.sh).

**Cara 2: pipx (dari PyPI)**

```bash
# Ubuntu 24.04 / Debian 12 melarang pip ke Python sistem, jadi pakai pipx:
apt install -y pipx && pipx ensurepath
pipx install myosa-agent
```

**Cara 3: manual dari source**

```bash
python3 -m venv ~/myosa-env
~/myosa-env/bin/pip install -U openai rich pillow

git clone https://github.com/reinhald90/Myosa-Agent.git
cd Myosa-Agent
echo "alias myosa='~/myosa-env/bin/python ~/Myosa-Agent/myosa.py'" >> ~/.bashrc
source ~/.bashrc
```

**Perbarui dan hapus**

```bash
myosa --version
myosa --update                                   # Cara 1 dan 2 (sumber: GitHub)
curl -fsSL https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/install.sh | bash -s -- --uninstall
```

`--uninstall` hanya menghapus program. API key dan konfigurasi di `~/.myosa/` tetap ada.

Jalankan di **tmux** supaya sesi dan watcher Shield tidak mati saat koneksi putus:

```bash
tmux new -s myosa
myosa
```

Periksa kondisi semua komponen kapan saja dengan `/doctor`.

---

## 🔌 Provider API

Myosa bisa memakai penyedia API apa pun yang kompatibel dengan OpenAI. Key tiap provider disimpan di satu file:

```bash
nano ~/.myosa/.env.local
chmod 600 ~/.myosa/.env.local
```

```ini
# ~/.myosa/.env.local  (RAHASIA, jangan pernah di-commit)
ZYVOR_API_KEY=isi_key_lengkap
APINEX_API_KEY=isi_key_lengkap
```

Nama variabel dibuat dari nama provider: `nama` menjadi `NAMA_API_KEY`.

```text
/provider            pilih / tambah / hapus provider (menu panah)
/provider add apinex tambah provider (preset APInex tersedia)
/provider use NAMA   beralih provider
/env                 lihat status key (disamarkan)
/env reload          muat ulang setelah mengedit .env.local
```

- Key yang berisi karakter tidak valid (misalnya `…` dari key yang terpotong) otomatis ditolak dengan pesan yang jelas.
- Status model dan model terakhir disimpan **terpisah per provider**.
- Provider lain yang kompatibel OpenAI bisa ditambahkan dengan `/provider add NAMA URL`.

---

## ⌨️ Perintah

| Perintah | Fungsi |
|----------|--------|
| `/help` | Daftar perintah |
| `/model` | Pilih model (menu panah, status aktif/mati) |
| `/health [kata]` | Cek model mana yang hidup |
| `/provider` | Kelola penyedia API |
| `/engine` | Pilih engine: myosa / opencode |
| `/mode` | `dev`, `eng`, `ops`, `cyber`, `data`, `riset` |
| `/deep` | Kedalaman berpikir: normal / dalam / ekstrem |
| `/shield` | Pelindung VPS |
| `/izin` | Tingkat izin L0-L3 |
| `/otonom` | Mode otonom dengan batas langkah dan waktu |
| `/gh` | GitHub: `login`, `repo`, `status`, `id`, `push`, `pr`, `logout` |
| `/tools` | Daftar alat yang tersedia |
| `/sys` | Info server ringkas |
| `/note`, `/notes` | Catatan lintas sesi (`~/.myosa/notes.md`) |
| `/export` | Simpan percakapan ke file `.md` |
| `/audit [host]` | Audit keamanan read-only, lalu laporan oleh agent |
| `/guard on\|off\|reset` | Pengaman bagian sensitif |
| `/evolve <fitur>` | Minta Myosa membuat plugin baru |
| `/plugin` | Kelola plugin |
| `/doctor` | Periksa semua komponen |
| `/rollback`, `/undo` | Pulihkan inti Myosa / batalkan edit file terakhir |
| `/anim`, `/logo`, `/hidup` | Animasi berpikir, animasi logo, mode Myosa hidup |
| `/host` | Kelola server SSH terdaftar |
| `/key`, `/auto`, `/think`, `/save`, `/load`, `/clear`, `/exit` | Utilitas |
| `!perintah` | Jalankan shell langsung |
| `/sh` | Shell interaktif penuh |
| `@file.png` | Lampirkan gambar atau file di pesan |

---

## 🧭 Mode

- **dev**: developer dan coding.
- **eng**: engineering dan arsitektur.
- **ops**: administrasi server dan DevOps (instalasi, konfigurasi, monitoring).
- **cyber**: keamanan **defensif** untuk server milik sendiri. Tidak ada exploit, brute force, atau pemindaian target pihak lain.
- **data**: data dan AI.
- **riset**: riset dan dokumentasi.

---

## ⚠️ Batasan (baca ini)

- **Guard bukan sandbox.** Deteksi bagian sensitif berbasis pola teks. Perintah yang disamarkan bisa lolos. Awasi sendiri di server penting.
- **Shield hanya aktif selama Myosa terbuka.** Perlindungan yang tetap hidup saat Myosa ditutup datang dari fail2ban dan ufw hasil `/shield harden`.
- Langkah **SSH key-only** bisa mengunci kamu di luar VPS. Uji login dengan key di sesi kedua sebelum menyetujui.
- Deteksi port scan butuh langkah **"Catat log firewall"** dari `/shield harden`.
- `.env.local` adalah **teks biasa** yang dilindungi izin file, bukan enkripsi.
- Model kecil (mis. varian `flash`) kadang kurang rapi memanggil tool.
- **Izin L2 dan L3 melonggarkan agent.** Pakai hanya di server yang kamu pahami, dan awasi di tmux.
- Sub-agen dan mode otonom **menambah jumlah panggilan API** (biaya dan batas laju).
- Token login GitHub disimpan sebagai teks di disk (izin file 600). Siapa pun yang punya akses root ke VPS bisa membacanya.
- **Khusus Ubuntu dan Debian.** Distro lain, macOS, Windows, dan Termux native tidak didukung dan belum diuji.

---

## 📁 Berkas konfigurasi

```text
~/.myosa/.env.local    API key tiap provider (izin 600)
~/.myosa/config.json   pengaturan (tanpa key)
~/.myosa/hosts.json    server SSH terdaftar
~/.myosa/plugins/      plugin buatanmu / hasil /evolve
~/.myosa/notes.md      catatan lintas sesi
~/.myosa/github-user.json   token login GitHub (izin 600)
~/.myosa/github.json   (opsional, pemilik) konfigurasi mode bot
~/.myosa/backup/       cadangan inti myosa.py
~/.myosa/bans.json     IP yang diblokir Shield
~/.myosa/shield.log    log peringatan Shield
```

**Jangan pernah meng-commit folder `~/.myosa/`, file `.env*`, atau file `.pem`.**

---

## 📚 Dokumen lain

- [`Agent.md`](Agent.md): identitas, kemampuan, dan cara kerja agent.
- [`Rules.md`](Rules.md): aturan wajib untuk agent, pengguna, dan kontributor.

---

<div align="center">

<img src="https://raw.githubusercontent.com/reinhald90/Myosa-Agent/main/logo.png" alt="Myosa" width="96">

**MYOSACODE AGENT** · dibuat oleh [reinhald90](https://github.com/reinhald90) (Azure Tech)

Lisensi [MIT](LICENSE)

</div>
