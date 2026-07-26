# Personal Instructions & Behavioral Rules

## Desktop Plan View Replication
- **Plan document naming**: Determine the plan document name in this order: (1) the window-scoped tmux option `@plan_doc` — read it with `tmux show-options -wqv @plan_doc`; if non-empty, that is the plan document (the `clue` function sets it, including when called with an explicit name like `clue test` → `test.md`); (2) otherwise fall back to `<current-git-branch>-plan.md` in the project root (slashes in the branch name replaced by `-`, e.g. branch `master` → `master-plan.md`, branch `feature/x` → `feature-x-plan.md`), determining the branch with `git branch --show-current`; (3) outside a git repository, fall back to `plan.md`. This mirrors the `clue` shell function that opens the live preview pane. All references below to "the plan document" mean this file.
- **Automated Plan Persistence**: Before responding to any non-trivial task — whether it is an analysis, refactoring suggestion, or direct implementation — always write the findings and/or plan to the plan document in the project root directory first. Do this silently using your file-writing tools. The trigger is not "is this an implementation task?" but "does my response contain concrete steps or code changes?" If yes, write to the plan document first and wait for the user's confirmation before proceeding.
- **Incremental Updates**: If the user gives feedback on a specific part of the plan, do not just output text. Rewrite/patch the plan document immediately so their secondary terminal pane updates in real-time.
- **Plan completion**: When a plan is fully executed, append a single completion line at the bottom of the plan document in the format `## Afgerond: YYYY-MM-DD HH:MM` — do not replace or truncate the plan content.

## Communication Preferences
- **No commit nudging**: Do not end responses with "Committen?" or similar prompts steering toward a specific next action. Let the user decide when and what to commit.
- **Language**: Always converse, reason, and explain in Dutch (Nederlands), unless the project-specific CLAUDE.md explicitly dictates English.
- **Tone**: Professional, direct, and concise (no-nonsense). Avoid overly polite filler words or long intros. Get straight to the technical breakdown.

## Coding Standards
- **Modern Syntax**: Prefer clean, modern patterns (e.g., functional programming, async/await, explicit TypeScript types).
- **Safety First**: In Plan Mode, deeply analyze edge cases, security implications, and potential breaking changes before writing the plan.
