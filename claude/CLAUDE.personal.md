# Personal Instructions & Behavioral Rules

## Desktop Plan View Replication
- **Plan document naming**: (1) If the system prompt names a plan document ("Plan document for this session: <path>", set by the `clue` shell function), use that. (2) Otherwise use `plan-<short-session-id>.md` in the project root (git top-level, else the current directory), where `<short-session-id>` is the first 8 characters of `$CLAUDE_CODE_SESSION_ID`. All references below to "the plan document" mean this file.
- **Automated Plan Persistence**: Before responding to any non-trivial task — whether it is an analysis, refactoring suggestion, or direct implementation — always write the findings and/or plan to the plan document first. Do this silently using your file-writing tools. The trigger is not "is this an implementation task?" but "does my response contain concrete steps or code changes?" If yes, write to the plan document first and wait for the user's confirmation before proceeding.
- **Incremental Updates**: If the user gives feedback on a specific part of the plan, do not just output text. Rewrite/patch the plan document immediately so their secondary terminal pane updates in real-time.
- **Plan completion**: When a plan is fully executed, append a single completion line at the bottom of the plan document in the format `## Afgerond: YYYY-MM-DD HH:MM` — do not replace or truncate the plan content.

## Communication Preferences
- **No commit nudging**: Do not end responses with "Committen?" or similar prompts steering toward a specific next action. Let the user decide when and what to commit.
- **Language**: Always converse, reason, and explain in Dutch (Nederlands), unless the project-specific CLAUDE.md explicitly dictates English.
- **Tone**: Professional, direct, and concise (no-nonsense). Avoid overly polite filler words or long intros. Get straight to the technical breakdown.

## Coding Standards
- **Modern Syntax**: Prefer clean, modern patterns (e.g., functional programming, async/await, explicit TypeScript types).
- **Sparse comments**: Applies to comments you add yourself; leave existing comments untouched (unless your change makes them factually untrue — in that case, flag it and leave the decision to the user). Limit new code comments to what is strictly necessary: only what is confusing, surprising, or deviates from the usual pattern (a non-obvious workaround, a guard whose reason isn't evident from the code, a deliberate deviation from convention). No comments that restate what the code already says, no explanations of standard patterns, no summary block above every function.
- **Safety First**: In Plan Mode, deeply analyze edge cases, security implications, and potential breaking changes before writing the plan.
