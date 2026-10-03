# Todoist collaboration

Reached only for sharing, assignees, workspaces, folders, shared labels, and notifications. Run `td <command> --help` for exact flags.

## Shared projects

```bash
td project collaborators "Roadmap"
td project share "Roadmap" alice@example.com
td project share "Roadmap" alice@example.com --message "Join the planning"
td project share "Team Plan" bob@example.com --role guest --auto-invite  # workspace project
td project join id:abc123                                                # join via share link
td project move "Roadmap" --to-workspace "Acme" --folder "Engineering" --visibility team --yes
td project move "Roadmap" --to-personal
```

`--role` and `--auto-invite` apply to workspace projects only. `--visibility` is `restricted`, `team`, or `public`.

## Assignees

Assign to a person (`name`, `email`, `id:xxx`, or `me`) on shared tasks:

```bash
td task add "Review spec" --project Work --assignee alice@example.com
td task update "Review spec" --assignee me
td task update "Review spec" --unassign
td task list --assignee "me" --unassigned       # --assignee takes me or id:xxx
td today --any-assignee                          # include tasks assigned to anyone
```

Quickadd syntax adds an assignee inline with `+Person`.

## Workspaces and folders

```bash
td workspace list
td workspace view "Acme"
td workspace use "Acme"                          # persist a default; omitted refs fall back to it
td workspace use --clear
td workspace projects "Acme"
td workspace users "Acme" --role ADMIN,MEMBER
td workspace user-tasks "Acme" --user alice@example.com
td workspace activity "Acme" --user-ids "id1,id2"
td workspace insights "Acme" --project-ids "id1,id2"
td workspace create --name "Acme" --description "Acme Inc."
td workspace update "Acme" --description "Acme Inc." --dry-run   # admin only
td workspace delete "Old WS" --yes                                # admin only

td folder list "Acme"
td folder view "Engineering"
td folder create "Acme" --name "Engineering"
td folder update "Engineering" --name "Platform" --workspace "Acme"
td folder delete "Engineering" --workspace "Acme" --yes
```

Workspace projects nest under folders, not under parent projects. `td project list` supports `--workspace` and `--personal` to scope the listing.

## Shared labels

Shared labels appear in `td label list` and `td label view`, but standard `label update`/`label delete` only work on labels that have an ID. Manage shared ones separately:

```bash
td label rename-shared oldname --name newname
td label remove-shared oldname --yes
```

## Comments and notifications

Notifications target only the users handed to the command. Writing `@Ana` in the text notifies nobody — name her explicitly:

```bash
td comment add <task-ref> --content "@Ana could you review?" --notify "Ana"
td comment add <task-ref> --content "Note to self" --no-notify
```

Omitting `--notify` notifies whoever the Todoist apps would (the task's assignee/assigner/creator on a first comment, or the previous comment's participants on a reply). Notification happens only when adding a comment, never when editing one.

```bash
td comment list "Roadmap" --project
td notification list --unread
td notification view id:123
td notification accept id:123                    # accept a share invitation
td notification reject id:123
td notification read --all --yes
```

## Attachments

`td comment add <task-ref> --content "See attached" --file ./report.pdf` attaches a file. Read one back with `td attachment view <file-url>`; never `curl` + `Read` a Todoist file URL (a rejected image gets pinned in context).
