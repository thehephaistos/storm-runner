# Prompt: Web export and itch.io upload

Given to Claude Code in this repo. It follows the Storm Runner itch.io Release Sheet. The butler key never goes to Claude Code: the push runs in your own Terminal window.

## The prompt

```
Export Storm Runner for the browser and get it onto itch.io, following the
itch.io Release Sheet.

Export
- Install Godot 4.7.2's web export templates if they're missing (only the
  web_nothreads files are needed).
- Use the "Web" preset in export_presets.cfg: Thread Support off, export path
  build/web/index.html, so index.html sits at the root of build/web.
  Keep physics/common/physics_ticks_per_second = 60. Keep build/ out of git.
- Export headless, then check that threads are disabled in index.html and
  index.html is at the root of build/web.

Upload with butler
- Target: oguzk/storm-runner:html5. That's my itch.io username, the
  storm-runner page, and the fixed html5 channel, pushed from build/web.
- The API key is read from BUTLER_API_KEY at push time only. Never ask me to
  paste it, and never write it into a command, a file, the log or the repo.
  Give me one Terminal line that reads it with read -s, pushes, and runs
  butler status.

Hand back
- the export checks: threads off, index.html at the root, 60 ticks per second;
- the butler status result showing the html5 upload finished processing,
  with no key in it;
- the live link;
- in DESIGN_LOG.md, below DC-12, with DC-01 to DC-12 left untouched: the
  link line "- itch.io build (live): https://oguzk.itch.io/storm-runner
  (uploaded <date>)", a short release note, and the browser-run screenshot.
  Then commit and push.
```

## The Terminal line (you run it, with your key)

```
read -s "BUTLER_API_KEY?Paste your itch.io API key: " && export BUTLER_API_KEY && ~/.butler/butler push ~/Desktop/academics/storm-runner/build/web oguzk/storm-runner:html5 && ~/.butler/butler status oguzk/storm-runner:html5
```

Nothing shows on screen while you paste the key. Wait for the status table, then close the window. The key goes with it.

## What we learned the first time

- itch.io refuses uploads until the account's email address is verified. The first push failed with: `400 ... Please verify your account's email address before uploading a build`.
- Save the itch.io page before the first push, because butler can only push to a page that exists.
- After the first push, tick **"This file will be played in the browser"** on the html5 upload under Edit game.
- With Restricted visibility, a logged-out visitor sees "You do not have access" until **"Also allow a password to view page"** is ticked, a password is set and saved. Share the password privately, never in the repo.
