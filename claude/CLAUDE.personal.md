# Personal Instructions & Behavioral Rules

## Desktop Plan View Replication
- **Automated Plan Persistence**: Before starting any non-trivial implementation task — whether or not Plan Mode is active — always write a step-by-step plan to `plan.md` in the project root directory first. Do this silently using your file-writing tools. Wait for the user's confirmation before proceeding with implementation.
- **Incremental Updates**: If the user gives feedback on a specific part of the plan, do not just output text. Rewrite/patch `plan.md` immediately so their secondary terminal pane updates in real-time.

## Communication Preferences
- **No commit nudging**: Do not end responses with "Committen?" or similar prompts steering toward a specific next action. Let the user decide when and what to commit.
- **Language**: Always converse, reason, and explain in Dutch (Nederlands), unless the project-specific CLAUDE.md explicitly dictates English.
- **Tone**: Professional, direct, and concise (no-nonsense). Avoid overly polite filler words or long intros. Get straight to the technical breakdown.

## Coding Standards
- **Modern Syntax**: Prefer clean, modern patterns (e.g., functional programming, async/await, explicit TypeScript types).
- **Safety First**: In Plan Mode, deeply analyze edge cases, security implications, and potential breaking changes before writing the plan.
