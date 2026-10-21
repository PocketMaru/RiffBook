# RiffBook project plan

## Review branch workflow — October 21

- Foundation work is isolated on review/model-persistence-foundation for
  Richard (@rlziii). Further work starts on feature/remaining-persistence-clients,
  based on that review branch, so it can proceed before review completes.
- Preserve the review branch while feedback is pending. Future continuation PRs
  should initially target the foundation branch to show only follow-up changes;
  retarget/rebase onto main after the foundation merges, according to merge style.
- CODEOWNERS assigns all files to @rlziii. It only becomes the main branch's
  ownership policy after it is merged into main.
- Enforcement requires main branch protection: pull requests, one approval,
  code-owner approval, dismiss stale approvals, no administrator bypass, no
  force pushes or deletions. Current Git credential lacks administration API
  permission; enforcement is pending admin configuration, not yet guaranteed.
- Uncommitted DESIGN.md and Concepts/ remain local and outside the review PR.

## Grouped local commits — October 21

- User now uses Sublime Merge. Organized app work into separate commits for
  configuration, theme assets, domain models, SQLite tables, database setup,
  repositories, clients, and the app-root scaffold. No remote publication.
- Song repository implements create/update/delete with propagated errors;
  update detects a missing row. SongClient forwards to the repository.
  Other client/repository files remain placeholders.
- AppRoot owns a static store and installs the database before store creation.
  AppFeature and AppView are unfinished scaffolds; this snapshot is not claimed
  to build or provide working capture/UI. Swift database round-trips remain
  unverified. Design and browser concept changes remain outside this commit set.
- Removed stale index-only entries under Core/Clients; current client files
  live under Core/Database/Clients. Preserved working source contents.

## Schema alignment — October 16

- Confirmed Song and SongRecord both use tuning, with no key; corrected the
  starter songRecords SQL to match. Added tuning to the riffRecords SQL.
- Confirmed Session.Update no longer exposes creationDate. RecordingRecord has
  been recreated by the user. Domain models and Git staging were left unchanged.
- Validated all four SQL schemas against record fields and exercised in-memory
  inserts/selects, including tuning. These checks do not verify Swift client
  round-trips or database startup, which remain pending.

## Recording record cleanup — October 15

- Removed the leftover untracked RecordingRecord.swift at the user's request so
  they can recreate the file in Xcode. No other source referenced its type.
- Earlier schema/build validation describes the prior snapshot; the recording
  record model now awaits user recreation. Other source and staging left alone.

## Current status

- GitHub-connected repository uses `main`.
- App and local packages live together in one repository.
- `App/RiffBook/` contains the initial project and local package.
- Swift/Xcode ignore rules and repository documentation are in place.
- GitHub-connected repository consolidated at this root, preserving its initial
  commit and `origin` (`https://github.com/PocketMaru/RiffBook.git`).
- App project is in `App/RiffBook/`; RiffBookCore is in `App/RiffBook/RiffBookCore/`.
- Open `RiffBook.xcworkspace` to resolve the local library and TCA dependency.
- App and package minimum deployment targets are iOS 27.0 (Swift tools 6.4).
- App currently displays the starter SwiftUI view; package tests are placeholders.
- Restored the original package location beside the project and removed the
  unused `Packages/` directory, per the chosen layout.
- October 13, 2026: unsigned simulator build succeeded through the workspace,
  including RiffBookCore and TCA.
- Initial project setup committed as `5555d7e` and verified on GitHub `main`.
- Product design is documented in `DESIGN.md`, including riffs, takes, songs,
  jam sessions, media presentation, guided tablature, and printable export.

## October 13 screen direction

- Updated `DESIGN.md` to version 2: songs replace groups; songs reference riffs.
- Launch: two-column riff cards; restore saved filter/sort, most recent by default.
- Top-left account information; top-right new riff/session and audio/video picker.
- Draft opens the chosen recorder before optional metadata entry.
- Song-building view: persistent horizontal song strip, add song with name/key,
  horizontal riff cards, and lower riff detail after selection.
- Tapping a song with a selected riff asks to add it; membership never copies media.
- Song cards open contained riffs; sessions open recordings with Create Riff.
- Dark Apple Music-inspired concept; design-system integration awaits user input.
- Concept navigation uses Riffs / Build / Songs / Sessions provisionally.
- Preview verified in browser: two-column library, riff selection, song-add
  confirmation/membership update, simulated first-take save, and session-to-riff
  conversion with the source recording removed. All 14 screen states render;
  no JavaScript errors observed.
- Interactive concept uses sample data and simulated capture, playback, and
  assignment only. App source and shipped behavior remain the starter scaffold.

## Browser concept export

- Exported `Concepts/riffbook-preview.html` as a standalone browser page.
- Keep `Concepts/riffbook-screen-concept.html` as the editable source; regenerate
  the browser export after concept changes so both stay synchronized.
- Browser export remains available locally and is also hosted behind a server-side passcode gate at
  https://riffbook-design-preview.ambid.chatgpt.site (version 3 deployed successfully).
- Stable Site ID: `appgprj_6acedc28e2dc8191b92d40e40c20632e`.
  Preserve this ID and slug on every future publish; never create another Site
  for routine preview updates. Identity copy: `Concepts/hosting.json`.
- Separate Sites source checkout:
  `/Users/joshuahauer/.codex/visualizations/2026/10/14/01a137bd-137b-7690-ab60-40e148ac59bd/riffbook-hosted-preview`.
  Its Git history belongs to Sites, not the app's GitHub repository.
- For concept changes: regenerate the browser export, embed it into that checkout's
  `worker/index.js` using `worker/gate.template.js`, preserving the server gate;
  run gate checks and Worker build/validation, sync/package using the Sites
  workflow, save the matching
  source version, and deploy it to the same Site. Update this plan with results.
- Felix can enter the shared passcode without ChatGPT sign-in and refresh after
  a publish. Signed secure HttpOnly cookies expire after 12 hours. Swift app changes
  do not automatically update the concept; keep the concept in sync explicitly.
- Sharing intent updated: link plus shared passcode; sample data/simulated flows only.
  Passcode and cookie-signing key live in Sites runtime secrets, never in the
  client bundle or app repository. The Sites route remains publicly reachable
  to show the login form; the Worker protects the actual preview server-side.
- Live browser verified: passcode screen shown before entry; requested passcode
  unlocks the concept at the same URL.
- Gate checks passed for incorrect/correct entries, inaccessible preview routes,
  cookie tampering, cross-origin form submissions, and missing-secret failure.

## Riff artwork direction

- First successful recording save establishes the riff's resting artwork:
  persist a random palette background and waveform from a fixed beginning segment.
- Preserve opening silence; segment duration/bar count remain undecided.
- During playback, animate the waveform from the selected recording's current
  audio levels in sync with playback/seek position; keep the background stable.
- Every playable riff card/box follows the shared player and actual take.
- Pause retains waveform position; paused seeking updates from file/cached data;
  resume continues in sync. Stop/end behavior remains open.
- Live values do not overwrite resting artwork. Scaling/smoothing and
  reduced-motion behavior remain open.
- Add a persisted optional favorite take: fresh card playback uses it, with
  latest saved take as fallback. Saving another take preserves the favorite.
- Explicit take playback and paused resume preserve that actual take/position.
- Favorite must belong to the riff; moving/deleting it clears the reference.
  Changing favorite during playback applies to the next fresh play provisionally.
- Interactive concept updated: independent card play controls, favorite stars,
  shared simulated playback timeline, waveform animation, paused seeking, and
  a mini player across views. Real audio analysis and Swift implementation pending.
- Browser verified favorite playback, animated waveform, paused hold/seek, and
  shared playback state across Library and Build. Version 3 deployed successfully
  to the same passcode-protected URL; gate checks passed.

## Decisions

- Store the app project in `App/`.
- Store local Swift packages beside the Xcode project in `App/RiffBook/`.
- Use local package references while developing in this repository.
- Track shared Xcode schemes and `Package.resolved` files.
- Read this plan before project work and update it when the project changes.
- Use `DESIGN.md` as the product source of truth; keep implementation progress
  and next steps in this plan. Proposed defaults and unresolved design decisions
  are labeled in the design rather than treated as confirmed requirements.

## Next step

October 15 metadata decision: add optional riff tuning separately from musical
key, available without tablature. Proposed UI offers presets (Standard, Drop D,
Drop C) plus custom entry and an unset state. Model/contracts, database migration,
clients, and preview support are pending; exact representation remains open.

Review the interactive screen concept in `Concepts/riffbook-screen-concept.html`,
settle navigation and the Build label, then incorporate the supplied design
system before implementing the first functional slice.

## Later

- Settle package boundaries and architecture as the first functional slice develops.
- Replace the generated placeholder test with meaningful behavior tests as logic is added.
- Implement real capture, durable save, playback, and meaningful reducer tests.
- Add song memberships and session conversion after the core capture slice.

## Design-system installation review

- User added TCA, SQLiteData, and AmbidDesignSystem to RiffBookCore's manifest.
- AmbidDesignSystem 0.7.1 exports product/module `DesignSystem`; target dependency
  must use `.product(name: "DesignSystem", package: "ambiddesignsystem")`.
  The user corrected the target product and reports it works; current manifest
  requests `DesignSystem`. No consumer code was changed during the review.
- Updated the sibling design-system README/PLAN with complete installation and
  import instructions. No consumer integration fix or build verification claimed.

## Neutral design-system example keys

- Local sibling package change replaces generated `example.connie.*` extras with
  `example.palette.*`. Standard colors and `example.recipe.*` remain unchanged.
- Older saved/exported sample keys migrate on document load/import and AI review;
  identities/values remain intact and conflicting values report an error.
- The neutral-key implementation was initially local; it is now released as
  0.8.0 and installed in RiffBook (see release verification below). Consumer
  source and hosted concept remain unchanged by this package update.
- Package verification completed: 69 tests and nine platform/public-example
  compilation checks passed. Generated test signing needed Finder-metadata
  cleanup; RiffBook integration/build was not changed or retested.

## Design-system 0.8.0 release verification — October 13

- Published approved package changes to `PocketMaru/AmbidDesignSystem` main and
  annotated tag `0.8.0`; verified tag dereferences to
  `39b02f8f1268a0efe01378c6bfc8869d83fcf9eb`.
- Updated RiffBookCore's version floor and both Xcode lockfiles to 0.8.0.
- Workspace simulator build passed with only resolved versions; DesignView import
  compiled successfully. SQLiteData stays at 1.12.0 and other existing pins stay
  unchanged. Initial resolution selected 1.12.1; restored the existing pin before
  the final successful build.
- Source/project SHA-256 preservation checks passed. No app source, project
  settings, or Git staging changed; consumer manifest/lockfile/plan changes remain
  uncommitted. No RiffBook GitHub push or hosted-preview update.
- Package validation: 69 tests and nine platform/public-example compile checks
  passed before publication. Next: use the updated workshop to import the
  RiffBook palette and continue the first functional test-UI slice.

## Design-system README usage audit

- Improved sibling README with a complete app/workshop demo, stable saved-theme
  ID selection/restoration, JSON route guidance, and setup troubleshooting.
- All three public-import examples compile across nine supported platform
  targets; local links and diff hygiene pass. Documentation is local/uncommitted.
- RiffBook source, dependencies, theme values, and hosted concept are unchanged.

- Further README clarification separates workshop editing/checkmark saving from
  direct `DesignThemes.save(document)` and optional JSON export/import. Explains
  documents vs configurations, app-local storage, and active-theme selection.
  Docs remain local; app implementation and package version are unchanged.

- Published approved design-system README setup/saving clarification to
  PocketMaru/AmbidDesignSystem main as `1bf5d5b`. Documentation-only commit;
  no new package release, RiffBook dependency update, or app GitHub push.

## Direct design-theme workshop input — October 14

- User direction: create a DesignTheme externally and pass it directly to
  DesignView; empty view uses ExampleTheme. Package owns document setup.
- Local sibling implementation adds the direct initializer; name/appearance
  are optional, saved-document support remains, and saving/applying stay explicit.
- This is not released or installed in RiffBook yet. Consumer source is unchanged.
- Direct-input verification: 72 package tests, nine platform checks, and external
  public-import initializer checks passed. The new API remains local/unreleased.

## Named theme / direct workshop release — October 14

- Published DesignSystem 0.9.0 at `4fc693a800c387eaa0674ee7da3869224540dd2b`
  to PocketMaru/AmbidDesignSystem main/tag; remote refs verified.
- Theme model owns its name. DesignView accepts the theme directly, handles
  document creation internally, and uses ExampleTheme when opened empty.
- Updated consumer requirement and both lockfiles to 0.9.0, retaining other pins.
- Restored the missing `color(hex)` converter in AppDesign's existing palette,
  named it RiffBook Midnight, and passed it directly to the ContentView workshop
  and preview with dark appearance. No document helper or JSON steps required.
- Final simulator build passed for the tested snapshot. Ongoing user edits to
  Features/Riff/Model/Riff.swift occurred during verification and were left alone;
  other pre-existing source/project files compare unchanged except the two
  intentionally edited theme/workshop files.
- Package: 74 tests and nine platform/public-example checks passed.
- RiffBook changes remain uncommitted; no app push or hosted concept update.

## Xcode scope-error inspection — October 14

- Live Downloads/Xcode window is the standalone RiffBook.xcodeproj and displays
  DesignSystem 0.7.1 even though both on-disk lockfiles pin 0.9.0.
- ColorScheme.swift currently calls color(hex) but no longer defines the helper,
  in both the visible editor and saved file. AppDesign and ContentView remain
  in the same Swift package target. Cannot-find-AppDesign is an editor diagnostic;
  stale package state and the invalid theme declaration need correction first.
- Read-only inspection of code; no source or UI configuration changed. Next:
  restore hex conversion and reopen the root workspace with refreshed resolution.

## Asset-backed RiffBook theme — October 14

- Added all 26 semantic palette colors with matching role names to
  RiffBookCore/Sources/RiffBookCore/Theme/Assets.xcassets, preserving exact sRGB
  values. Registered package resource processing and switched AppDesign to
  Color(name, bundle: .module). No local hex converter is needed.
- Fixed palette is currently the same in every appearance; no inferred light
  variant added. Asset catalog belongs to the package that owns the theme.
- Verified all 26 catalog entries/references. Theme and generated Bundle.module
  accessor type-check independently. Full simulator build is blocked by the
  in-progress Riff model's Codable conformance errors; model left unchanged.
  No commits or pushes requested.

- Live Xcode navigator had not refreshed the new package catalog and showed only
  ColorScheme under Theme. Opened the package Assets.xcassets directly in Xcode;
  verified all 26 named colors are visible. Original app catalog is separate.
  Existing project still shows stale DesignSystem 0.7.1 in its navigator.

## Project-owned package navigator — October 14

- Keep RiffBookCore nested inside the Xcode project, per user preference. Removed
  the separate workspace package entry and added explicit project-local package
  dependency wiring so resolution does not rely on that outer entry.
- Files stay in their existing locations; app product linkage remains.
- Workspace dependency resolution passed, including RiffBookCore and DesignSystem
  0.9.0. Diff hygiene passed; no commit or push.

## Model and persistence readiness review — October 14

- Riff, Song, Session, and Recording now use query selections; JSON representations
  cover ID arrays and effects. Create/Update contracts carry editable data, with
  updates initialized as complete editable snapshots. Repository owns timestamps.
- Riff includes one optional favorite and creation/update dates. RiffRecord,
  SongRecord, and SessionRecord mirror the current frontend models.
- Unsigned workspace simulator build passed for this snapshot; this does not
  verify database runtime behavior. Review log: /tmp/riffbook-current-review.log.
- Remaining persistence work: replace copied timer migrations with matching
  schemas/table names, add RecordingRecord, bootstrap the database at app startup,
  and implement clients with validated writes and selection queries.
- Decide whether ID arrays remain JSON storage or come from relationship tables;
  current records use JSON arrays. Recording.Create currently requires a name;
  repository-generated take naming still needs its input/default policy.
- App still opens the theme workshop. Feature reducers and functional test UI
  follow the persistence clients. User source and Git staging left unchanged.

## Initial SQL schemas — October 14

- Replaced copied timer columns with all fields from RiffRecord, SongRecord,
  SessionRecord, and the newly added RecordingRecord. Table names now match
  the macros' plural defaults: riffRecords, songRecords, sessionRecords,
  recordingRecords. STRICT schemas use TEXT for UUIDs, dates, raw media enums,
  and JSON arrays; favorite is nullable. Required record fields remain NOT NULL.
- Used Point-Free migration guidance and retained the existing #sql migration
  style. These are starter migrations, not a migration upgrade for a shipped app.
- Relationship ID arrays remain JSON; reference validation and recording ownership
  must be enforced by clients. No membership tables or delete policy introduced.
- Recording.Create.name stays required. Empty string requests repository-generated
  Take N naming; nonempty input supplies a custom name. Naming implementation
  awaits the recording client, along with durable file save and timestamps.
- Unsigned simulator workspace build passed. All four extracted CREATE TABLE
  statements and representative row inserts passed against an in-memory SQLite
  database. Actual Swift client round-trips remain unimplemented/unverified.
- Next: install the database dependency at startup and implement persistence
  clients with selection queries, validation, timestamps, and take naming.

## Foldable preview / glass navigation — October 14

- Concept now uses an iPhone Fold-style mockup with a keyboard-accessible opening
  slider: compact 360px through expanded 680px, constrained to available space.
  Expanded library/song grids use three columns; existing playback state survives
  resizing. Device dimensions are concept choices, not hardware specifications.
- Floating tab bar uses translucent blur, highlights, and a glass selection pill.
- Browser verified slider endpoints and expanded three-column layout. Gate checks,
  Worker build, and artifact validation passed. Saved Site version 4 at source
  1e3234207698778267a1eab0ade384482f33cc18; deployed successfully to the same URL
  with the existing passcode gate intact.

## Simulator-informed fold correction — October 14

- Reviewed Apple's iPhone Duo preparation guidance and live Xcode 27.1 Device
  Hub closed/partially open poses. Replaced continuous phone stretching with
  separate outer/inner aspect ratios and perspective-rendered hinge panels.
- Navigation glass now runs vertically beneath the trailing status/camera area,
  following the 27.1 design direction. Slider reports hinge angle 0–180 degrees.
- Intermediate hinge poses are visual previews; app controls are usable at the
  closed/open endpoints. This CSS concept approximates Device Hub, not its 3D mesh.
- Browser checked closed, 90-degree and fully open states, including rail bounds.
  Worker/gate checks passed; version 5 deployed to the existing URL with passcode
  preserved. Source commit: 9685742e125b3704f51b83aaa52bbf82b4389a55.
