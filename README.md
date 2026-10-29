# skills — branch `win`

37 skill untuk **DeepSeek Harness (DSH)** yang sudah disesuaikan agar berjalan native di Windows.

Setiap skill ada di `skills/<nama>/SKILL.md` dan mengikuti format resmi DSH: frontmatter `name` +
`description`, nama kebab-case, satu level di bawah root. Branch `main` hanya berisi halaman
dokumentasi.

## Isi

| Kelompok | Jumlah | Skill |
|---|---|---|
| Engineering | 20 | `ask-matt`, `code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grill-with-docs`, `implement`, `implement-spec`, `improve-codebase-architecture`, `pr`, `prototype`, `research`, `retro`, `setup-matt-pocock-skills`, `tdd`, `to-spec`, `to-tickets`, `triage`, `wayfinder`, `wizard` |
| Productivity | 7 | `grill-me`, `grilling`, `handoff`, `teach`, `to-questionnaire`, `wait-what`, `writing-for-agents` |
| Misc | 4 | `git-guardrails-claude-code`, `migrate-to-shoehorn`, `scaffold-exercises`, `setup-pre-commit` |
| Ponytail | 6 | `ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, `ponytail-review` |

16 di antaranya **user-only** (`disable-model-invocation`): hanya bisa dipanggil lewat `/nama` di
composer dan tidak muncul di katalog model — `ask-matt`, `grill-me`, `grill-with-docs`, `handoff`,
`implement`, `implement-spec`, `improve-codebase-architecture`, `retro`,
`setup-matt-pocock-skills`, `teach`, `to-questionnaire`, `to-spec`, `to-tickets`, `triage`,
`wait-what`, `wayfinder`.

## Yang dikustomisasi untuk Windows

| Skill | Perubahan |
|---|---|
| `diagnosing-bugs` | `scripts/hitl-loop.template.ps1` baru (padanan `hitl-loop.template.sh`), rujukan varian Windows di `SKILL.md` |
| `wizard` | `template.ps1` baru (library wizard lengkap: `banner`, `stage`, `ask`, `ask_secret`, `write_env`, `set_secret`, `finish`), langkah verifikasi PowerShell, deskripsi skill diperbarui |
| `git-guardrails-claude-code` | `scripts/block-dangerous-git.ps1` baru, plus catatan bahwa DSH tidak punya hook `PreToolUse` |

Aturan yang dipakai untuk semua skrip port:

- **ASCII murni**, karena Windows PowerShell 5.1 membaca berkas UTF-8 tanpa BOM sebagai ANSI dan
  eksekusinya gagal dengan pesan menyesatkan (`The term '<fungsi>' is not recognized`).
- Diuji di `pwsh` 7 dan `powershell.exe` 5.1.
- Mendukung input non-interaktif (jawaban dipipe), sehingga agen bisa menjalankannya.

Subdirektori `agents/openai.yaml` milik upstream dihapus karena itu metadata adaptor host lain.

## Instalasi

### Cara 1 — salin ke user root (terbukti)

```powershell
git clone -b win https://github.com/aryajava/skills.git "$env:USERPROFILE\skills-repo"
New-Item -ItemType Directory -Force "$env:USERPROFILE\.dsh\skills" | Out-Null
Copy-Item "$env:USERPROFILE\skills-repo\skills\*" "$env:USERPROFILE\.dsh\skills" -Recurse -Force
```

Skill terpasang di `~/.dsh/skills` (level `user-dsh`), berlaku untuk semua workspace dan sesi DSH
dengan home yang sama, dan langsung terdeteksi tanpa restart.

### Cara 2 — `customSkillDirs`

Clone repo, lalu arahkan root custom skill ke `<clone>\skills`. Cara ini hanya berlaku bila profil
DSH Anda benar-benar memuat baris `skill-filesystem` yang aktif; kalau ragu, pakai Cara 1 dan cek
panel Skill Center.

Urutan prioritas discovery DSH: proyek `.dsh/skills` (100) → proyek `.agents/skills` (200) → custom
(300) → user `~/.dsh/skills` (400) → user `~/.agents/skills` (500). Nama yang sama di sumber
berperingkat lebih rendah akan tertutup.

## Memperbarui

```powershell
Set-Location "$env:USERPROFILE\skills-repo"
git pull
Copy-Item ".\skills\*" "$env:USERPROFILE\.dsh\skills" -Recurse -Force
```

Port PowerShell dan suntingan dokumen ada di repo ini, jadi `git pull` tidak menghapusnya. Yang
harus dihindari adalah menimpa folder hasil clone dengan skill mentah dari upstream.

## Verifikasi

```powershell
(Get-ChildItem "$env:USERPROFILE\.dsh\skills" -Directory).Count   # 37
Get-ChildItem "$env:USERPROFILE\.dsh\skills" -Recurse -Filter *.ps1 -File
```

Di DSH: buka **Skill Center** (grup *User skills*) atau cek katalog skill pada sesi berikutnya.

## Batasan yang perlu diketahui

- **Ponytail tidak always-on.** `hooks/`, `commands/`, dan band-nya khusus Claude Code; di DSH skill
  aktif saat dipanggil (`/ponytail`) atau saat model memuatnya karena tugas cocok.
- **`block-dangerous-git.ps1` bersifat advisory.** DSH tidak punya hook `PreToolUse`, jadi skrip
  hanya memblokir perintah yang memang dijalankan melaluinya. Penegakan nyata butuh *tool guard*
  di plugin atau aturan `AGENTS.md`.
- Beberapa skill mengasumsikan tooling macOS/Linux atau issue tracker nyata (`gh`/`glab`); bagian
  itu perlu adaptasi sendiri.

## Lisensi

Konten berasal dari proyek MIT — lihat [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) dan teks
lisensi di `licenses/`.