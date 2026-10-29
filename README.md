# skills

Kumpulan skill untuk **DeepSeek Harness (DSH)**, disesuaikan agar berjalan native di Windows.

Repo ini punya dua branch:

| Branch | Isi |
|---|---|
| `main` | Halaman ini: dokumentasi singkat |
| [`win`](https://github.com/aryajava/skills/tree/win) | 37 skill siap pakai, sudah dipatch untuk Windows |

## Mulai cepat

```powershell
git clone -b win https://github.com/aryajava/skills.git "$env:USERPROFILE\skills-repo"
New-Item -ItemType Directory -Force "$env:USERPROFILE\.dsh\skills" | Out-Null
Copy-Item "$env:USERPROFILE\skills-repo\skills\*" "$env:USERPROFILE\.dsh\skills" -Recurse -Force
```

Skill langsung terdeteksi pada sesi DSH berikutnya, tanpa restart. Detail, opsi pemasangan lain, dan
daftar lengkap ada di [README branch `win`](https://github.com/aryajava/skills/blob/win/README.md).

## Isi

37 skill untuk alur kerja engineering dan produktivitas:

- **21 skill model-invocable** — dipanggil otomatis ketika tugasnya cocok, atau manual lewat `skill`.
- **16 skill user-only** — hanya lewat `/nama` di composer (`/grill-me`, `/tdd`, `/to-spec`, dan seterusnya).

Sumber: [mattpocock/skills](https://github.com/mattpocock/skills) dan
[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail), keduanya MIT.

## Kustomisasi Windows

Tiga skrip bash diupstream diport ke PowerShell dan diuji di `pwsh` 7 maupun Windows PowerShell 5.1:

| Skill | Skrip |
|---|---|
| `diagnosing-bugs` | `scripts/hitl-loop.template.ps1` |
| `wizard` | `template.ps1` (library wizard lengkap) |
| `git-guardrails-claude-code` | `scripts/block-dangerous-git.ps1` |

Semua skrip port disimpan **ASCII murni** supaya tidak rusak ketika Windows PowerShell 5.1 membaca
berkas. Dokumen skill juga disesuaikan: rujukan varian Windows, langkah verifikasi PowerShell, dan
catatan bahwa DSH tidak memiliki hook `PreToolUse` seperti Claude Code.

## Lisensi

Konten skill berasal dari proyek MIT. Teks lisensi dan atribusi lengkap ada di
[`THIRD-PARTY-NOTICES.md`](https://github.com/aryajava/skills/blob/win/THIRD-PARTY-NOTICES.md)
pada branch `win`.

Repo ini bukan proyek resmi DeepSeek Harness, Matt Pocock, maupun Ponytail.
