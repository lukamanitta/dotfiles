---
description: Lite HMS story workflow. Load a Jira ticket, plan it with you, implement in-place, and hand you a test plan. You own branches and commits.
---

# HMS Story (lite)

`$ARGUMENTS` is a Jira ticket key followed by optional notes — e.g. `HMS-12345 focus on the reception flow`.

Run this session from `~/projects/code/msi` — the umbrella `opencode.json` there enables the Atlassian MCP, and every target repo sits inside the project root.

The human owns git history: they create the branch, commit, and push. Your job is to load the ticket, plan it with them, implement it in their working tree, and tell them how to test it. You work in the existing clones and never create worktrees.

## Git rules (hard)

- You never create a branch, commit, push, stash, or run any history-writing git command.
- The branch in every repo you touch must be `<initials>/<TICKET>`, matched exactly and case-sensitively (e.g. `lm/HMS-12345`). `<initials>` is `git config user.initials` (fallback: the initials of `user.name`).
- If a repo is on `qa/*`, `main`, `master`, or a detached HEAD, or its branch name does not match, **halt**, name the expected branch, and wait for the human. Do not create it.

## Steps

### 1. Load the ticket

- Normalize the key to uppercase (`hms-12345` → `HMS-12345`).
- Fetch the issue through the Atlassian MCP (search, then read it as markdown). If the MCP is unavailable or errors, ask the human to paste the ticket.
- Never invent ticket content. If the fetch is partial, state what you have, mark your assumptions, and ask.
- Restate the summary, acceptance criteria, and your reading of the change. **Wait for the human to confirm** before continuing.

### 2. Orient

- Read the discovery cache: `~/projects/code/msi/.hms-kb/index.md`, then the matching `topics/*.md` and `repos/*.md`. Verify anything you rely on; treat the cache as a lead, not truth.
- Consult the team knowledge base: `~/projects/code/msi/hms-agents/AGENTS.md` and `knowledge/index.json` (filter by project and tags, read the matching KIs). Cite the KIs you apply.
- Propose the repos this story touches, one line of reasoning each, and **confirm** them with the human.
- Then check every target repo's branch in one pass and report **all** mismatches together — repo → current branch → expected `<initials>/<TICKET>` — so the human can fix them in one go. Halt until every repo passes.
- Locate the relevant models, actions, controllers, and components.
- Done when: the repos are confirmed and every branch check passes.

### 3. Plan

- Discuss the approach; resolve ambiguities before writing anything down.
- Write the plan to `~/projects/code/msi/.hms-stories/<TICKET>.md` (template below).
- For a risky or financial change, offer an adversarial critique pass; run it only if the human agrees.
- Present the plan and **wait for explicit approval**.
- Done when: the human approves.

### 4. Implement

- Build the approved plan. Treat approval as the green light; do not re-ask per file.
- On genuine ambiguity, or a change outside the plan, **stop and ask** before continuing.
- Follow the repo's conventions and the KIs you cited.
- Keep the plan file's status and checklist current as you go.
- Done when: every planned change is in place, or explicitly deferred with the human.

### 5. Verify

- Run what is runnable: fast/stubbed specs and lint for each changed repo (e.g. `bundle exec rspec <path>`, `bundle exec rubocop <path>`).
- The dev database is often down. Skip DB-dependent integration tests and say so, rather than guessing.
- Report two lists: **Ran** (command → result) and **Not run** (what → why).
- Done when: both lists are honest and complete.

### 6. Wrap

- Output the **Test plan** (template below).
- Update the knowledge base (rules below).
- Tell the human the story is ready for their testing. When they say it is done, move the plan file to `/tmp/hms-story/<TICKET>.md`.
- Done when: the test plan is delivered, the knowledge base is updated, and the plan file is moved.

## Knowledge base

Goal: make the next session on this codebase faster and more accurate. Record only what a future session would otherwise have to re-derive — a cache of discovery, not a diary.

Record:

- The cross-repo trail for a capability you touched: where it lives (model, action, service, controller, component paths).
- Fast paths: the one command or file that answered a question that cost you time.
- Gotchas: non-obvious constraints, surprising behavior, things that broke.
- Corrections: fix or delete a note that turned out wrong or stale.

Skip:

- Anything the code, a README, or `knowledge/index.json` already states plainly.
- A narration of what you did, or facts specific to this one ticket.

Where and how:

- A capability spanning repos → `~/projects/code/msi/.hms-kb/topics/<domain>.md`.
- Mechanics of one repo → `~/projects/code/msi/.hms-kb/repos/<repo>.md`.
- Name topics with the `knowledge/index.json` tags where they fit (`invoicing`, `permissions`, `alerts`, `transfers`, `lightservice`, `mongoid`, ...).
- A new file → add a one-line entry to `index.md`.
- Under **Where things live**, **Fast paths**, or **Gotchas**, add one dated bullet per fact in pointer form (paths, names, commands). Check first; merge or update rather than duplicate. Keep it terse.
- Keep `index.md` to one screen. When a topic file outgrows a screen, merge duplicates, compress verbose bullets, and drop notes that no longer change what a future session does. Judge by whether the next session behaves at least as well, not by whether every fact survives.

## Plan file template

```
# <TICKET> — <title>
- Ticket: <url>
- Branch: <initials>/<TICKET>
- Status: planning | implementing | ready-for-testing | done

## Understanding
<one paragraph + acceptance criteria>

## Plan
- [ ] <step>

## Decisions & assumptions
- <decision>

## Files touched
- <repo>/<path> — <purpose>

## Open questions
- <question>
```

## Test plan template

```
## Test plan — <TICKET>

**Automated**
- `<command>` — <coverage>

**Manual**
- Happy path: <steps>
- Edge: <steps>
- Failure: <steps>

**URLs**
- Main apps through `machine-setup/./dev up`: `https://aus.hms-lobby.test`, `https://aus.hms-reception.test`, and so on.
- Per-story hosts (`aus.hms-<app>-<ticket>.test`) need a live DB plus the Mongo territory sync; skip them while the DB is down.

**Eyeball**
- <what to check visually or in the logs>
```

## This machine

Read `~/projects/code/msi/context.md` for the repos, ecosystem map, dev environment (no puma-dev, ports, DB caveat), and test/lint commands. It is also loaded automatically when the session starts from `~/projects/code/msi`.
