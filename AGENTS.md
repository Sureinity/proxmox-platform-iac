From now on, every git commit message must strictly follow the Conventional
Commit format and no other commit style.

Use this format:
`type(optional-scope): short summary`

Rules:
- Allowed types only: `feat`, `fix`, `docs`, `refactor`, `test`, `style`, `chore`
- Use imperative mood
- Keep the summary concise
- Add a bullet-point body after the title
- Start each bullet with a verb
- Use `BREAKING CHANGE:` as a footer when applicable
- Do not use non-conventional commit messages under any circumstance
- If there are unstaged files, excluding `Makefile`, re-simulate the additions
  and changes inside this project directory and proceed committing every
  change
- Base commit sequencing on the last set of changes so versioning stays
  granular
- Every change made must be committed
- Never include `Makefile` and `AGENTS.md.git`
