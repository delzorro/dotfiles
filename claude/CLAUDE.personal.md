# Personal Instructions & Behavioral Rules

## Desktop Plan View Replication
- **Automated Plan Persistence**: Whenever the user switches to Plan Mode (or asks for an architecture/implementation plan), you must ALWAYS write or overwrite the full, updated step-by-step plan into a file named `plan.md` in the project root directory. Do this silently using your file-writing tools.
- **Line Number References**: In your chat responses, when discussing code changes or steps, always explicitly mention the exact line numbers from your generated `plan.md` (e.g., "See lines 12-15 in the plan"). This allows the user to easily reference and comment on it.
- **Incremental Updates**: If the user gives feedback on a specific part of the plan, do not just output text. Rewrite/patch `plan.md` immediately so their secondary terminal pane updates in real-time.

## Communication Preferences
- **Language**: Always converse, reason, and explain in Dutch (Nederlands), unless the project-specific CLAUDE.md explicitly dictates English.
- **Tone**: Professional, direct, and concise (no-nonsense). Avoid overly polite filler words or long intros. Get straight to the technical breakdown.

## Coding Standards
- **Modern Syntax**: Prefer clean, modern patterns (e.g., functional programming, async/await, explicit TypeScript types).
- **Safety First**: In Plan Mode, deeply analyze edge cases, security implications, and potential breaking changes before writing the plan.
