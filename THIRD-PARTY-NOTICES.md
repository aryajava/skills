# Third-party notices

Repo ini mendistribusikan ulang skill dari dua proyek berlisensi MIT, dengan modifikasi lokal agar
berjalan di Windows. Berkas lisensi asli ada di direktori `licenses/`.

## mattpocock/skills

- Sumber: https://github.com/mattpocock/skills
- Lisensi: MIT — Copyright (c) 2026 Matt Pocock
- Teks: [`licenses/mattpocock-skills-LICENSE.txt`](licenses/mattpocock-skills-LICENSE.txt)
- Skill yang didistribusikan: 31 (kelompok Engineering, Productivity, Misc)

## DietrichGebert/ponytail

- Sumber: https://github.com/DietrichGebert/ponytail
- Lisensi: MIT — Copyright (c) 2026 DietrichGebert
- Teks: [`licenses/ponytail-LICENSE.txt`](licenses/ponytail-LICENSE.txt)
- Skill yang didistribusikan: 6 (`ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`,
  `ponytail-help`, `ponytail-review`)

## Modifikasi lokal

- Tiga skrip PowerShell baru: `diagnosing-bugs/scripts/hitl-loop.template.ps1`,
  `wizard/template.ps1`, `git-guardrails-claude-code/scripts/block-dangerous-git.ps1`.
- Suntingan `SKILL.md` pada ketiga skill di atas: rujukan varian Windows, langkah verifikasi
  PowerShell, dan catatan batasan DSH.
- Deskripsi skill `wizard` disesuaikan agar menyebut PowerShell di Windows.
- Subdirektori `agents/openai.yaml` milik upstream dihapus (metadata adaptor host lain).

Modifikasi ini tidak mengubah lisensi konten aslinya; konten turunan tetap MIT dengan atribusi di
atas.
