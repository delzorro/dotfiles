# Personal Instructions & Behavioral Rules

## Desktop Plan View Replication
- **Automated Plan Persistence**: Whenever the user switches to Plan Mode (or asks for an architecture/implementation plan), you must ALWAYS write or overwrite the full, updated step-by-step plan into a file named `plan.md` in the project root directory. Do this silently using your file-writing tools.
- **Section Labels**: Structure every plan with short anchors like `[S1]`, `[S2]`, etc. before each section heading (e.g. `## [S1] Setup omgeving`). In your chat responses, reference these anchors when discussing steps (e.g., "zie S3 in het plan"). This allows the user to give targeted feedback like "pas S2 aan" without relying on line numbers that shift as the plan evolves.
- **Incremental Updates**: If the user gives feedback on a specific part of the plan, do not just output text. Rewrite/patch `plan.md` immediately so their secondary terminal pane updates in real-time.

## Communication Preferences
- **Language**: Always converse, reason, and explain in Dutch (Nederlands), unless the project-specific CLAUDE.md explicitly dictates English.
- **Tone**: Professional, direct, and concise (no-nonsense). Avoid overly polite filler words or long intros. Get straight to the technical breakdown.

## Coding Standards
- **Modern Syntax**: Prefer clean, modern patterns (e.g., functional programming, async/await, explicit TypeScript types).
- **Safety First**: In Plan Mode, deeply analyze edge cases, security implications, and potential breaking changes before writing the plan.
