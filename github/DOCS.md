# Home Assistant App: GitHub Sync

## Installation

1. Create a fine-grained personal access token on GitHub with access to the
   repositories you want to sync (Contents: read, plus write if you use `push`).
2. Install the app, fill in the options below and start it.

## Configuration

```yaml
github_token: ""
git_username: "your-github-name"
git_email: "you@example.com"
sync_interval: 15
repositories:
  - url: "https://github.com/your-name/my-vault.git"
    path: "obsidian"
    branch: "main"
    push: true
  - url: "https://github.com/your-name/project-a.git"
    path: "hermes/Projekt_A"
```

### Option: `github_token`

Token used for HTTPS access to `github.com`. Without it only public
repositories can be cloned.

### Options: `git_username` and `git_email`

Git identity used for commits and for the token authentication.

### Option: `sync_interval`

Minutes between sync runs (1 to 1440).

### Option: `repositories`

| Key | Description |
| --- | --- |
| `url` | HTTPS clone URL. |
| `path` | Target folder, **relative to `/share`** (no leading `/`, no `..`). |
| `branch` | Optional branch to clone. |
| `push` | If `true`, local changes are committed automatically and pushed. |

Use `path: obsidian` to match the Obsidian app's vault folder and
`path: hermes/<workspace>` to place a repository inside a Hermes Agent
workspace.

## Behaviour and caveats

- Pulls use `git pull --rebase --autostash`. If a rebase conflicts, the sync
  for that repository fails and is retried in the next run; resolve conflicts
  manually.
- Auto-commit and push can create conflicting commits when several devices edit
  the same files. Prefer a dedicated branch for such repositories.
- Only `/share` is mounted writable.
