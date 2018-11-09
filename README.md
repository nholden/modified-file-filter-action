# Modified File Filter for GitHub Actions
This action stops a workflow unless the file in the path specified in `args` has been modified.
It should only be included in workflows triggered by `push` events.

## Usage

```
workflow "Alert data team when database changes" {
  on = "push"
  resolves = ["Alert"]
}

action "Check" {
  uses = "nholden/modified-file-filter-action@master"
  args = "db/structure.sql"
}

action "Alert" {
  needs = ["Check"]
  ...
}
```
