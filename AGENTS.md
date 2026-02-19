# AGENTS.md

## Prompt Output Convention

When asked to produce a handoff prompt for a reviewer, output it using the
`[CODEX / REVIEW PROMPT TEMPLATE]` structure below.

If the user provides a custom template in chat, prioritize the user template.
If no template is provided, use this default one.

---

# [CODEX / REVIEW PROMPT TEMPLATE]
# Review: <FEATURE_NAME_JA> (<FEATURE_NAME_EN>)
# Repo: popcorn

You are a senior Rails reviewer. Review the implementation in this PR.

## 1. PR Information
- PR URL: <PR_URL>
- Base/Head: `<BASE_BRANCH>` <- `<HEAD_BRANCH>`
- Purpose:
  - <PURPOSE_1>

## 2. Changed Files
- <FILE_PATH_1>
- <FILE_PATH_2>
- <FILE_PATH_3>

## 3. Verification Steps (Manual)
1. <STEP_1>
2. <STEP_2>
3. <STEP_3>

## 4. Test Steps
1. <TEST_COMMAND_1>
2. <TEST_COMMAND_2>
3. <EXPECTED_RESULT>

## 5. Review Focus
- Functional correctness:
  - Acceptance criteria are fully satisfied.
  - No regressions in existing behavior.
- Frontend quality:
  - Responsive behavior (desktop/mobile) is stable.
  - Tailwind styling intent matches requirements.
- Hotwire usage:
  - Turbo and Stimulus responsibilities are appropriate.
  - Stimulus controller lifecycle/actions are correct.
- TypeScript quality:
  - Type safety and maintainability are reasonable.
- Accessibility:
  - Keyboard operation, focus handling, labels, and contrast are acceptable.
- Performance:
  - No obvious bottlenecks on first load.
- Security:
  - No unsafe external link handling or obvious injection risk.

## 6. Expected Review Output
1. Findings first, ordered by severity, with file paths and line numbers.
2. Open questions and assumptions.
3. Suggested fixes (concrete and minimal).
4. Short summary and merge readiness.

