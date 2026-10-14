# RiffBook product design

Version 1 • October 7, 2026

RiffBook is a private musical idea library. Capture an idea quickly through audio or video, develop it through multiple takes, organize it into groups, and optionally document it with guided tablature. The experience should make ideas memorable and easy to return to without interrupting playing.

This is the product source of truth. `PLAN.md` tracks implementation progress and the next task. This design describes intended behavior; it does not imply that features are implemented. Explicit requirements are separated from proposed defaults and open decisions below.

## Core principles

- Capture first, complete details later. Music theory and forms never gate recording.
- A riff is an idea. A recording is one take or variation of that idea.
- Keep developing the active riff until the user chooses New Riff or another capture destination.
- Jam sessions collect recordings before the user decides which ideas they belong to.
- Groups organize riffs without duplicating them.
- Presentation changes preserve the selected media and session state.
- Save recordings reliably and make their destination visible.

## Product vocabulary

| Concept | Meaning | Relationship |
| --- | --- | --- |
| Recording | One complete audio or video capture | Belongs to a riff or an unassigned jam session |
| Riff | A musical idea with details and a build of recordings | Can belong to multiple groups |
| Build | The ordered collection of takes developing a riff | Contains recording models, not stitched media |
| Group | A named folder-like collection, such as a song or ideas that work together | References riffs; a riff can appear in several groups |
| Jam session | A holding place for captures that have not become riffs | Recordings can become new riffs or join existing ones |
| View mode | Changes the presentation, such as audio album or video feed | Does not itself change membership |
| Filter | Restricts results by metadata or media availability | Does not move or modify content |
| Tablature | Optional structured instructions for playing a riff | Belongs to the riff |

A group named “Jam” is still a collection of established riffs. A jam session specifically holds recordings waiting to be assigned. They serve different purposes.

## Information model

### Riff

| Property | Purpose |
| --- | --- |
| Identity | Stable reference independent of its name |
| Name | User-editable title; capture may precede naming |
| Description | Optional context, reminders, or explanation |
| Guitar type | Optional electric, acoustic, or nylon classification |
| Tone | Optional clean or distortion classification |
| Musical key | Optional metadata retained from the original browse concept |
| Build | Ordered recordings with automatic or custom take names |
| Tablature | Optional tuning, sections, measures, and notes |
| Group memberships | Links to any number of groups |
| Created and updated dates | Support library ordering |

Guitar type and tone are separate fields. An electric riff can be clean. A riff may contain both audio and video; its first capture determines its initial recording mode, not a permanent media classification.

### Recording

A recording has a stable identity, name, media type, file reference, creation date, and position within its destination. Duration and a video thumbnail or audio visual representation support presentation.

Names default to Take 1, Take 2, Take 3, and so on within a riff. The user can rename any take, for example “Version with hammer-on” or “Slower version.” Renaming does not change identity or ordering.

**Proposed ownership rule:** each recording has one current owner: a riff or a jam session. Moving it changes ownership without duplicating or editing the file. An optional origin-session reference can preserve provenance later, but a session history policy is not yet settled.

The `build` property is the app-facing collection. Storage can represent it through related recording rows rather than placing all recordings inside a single database field.

### Group

A group has an identity, user-chosen name, and memberships referencing riffs. Adding a riff to another group creates another membership. Removing membership should leave the riff and recordings intact.

### Jam session

A session has an identity, name, dates, and an ordered collection of unassigned recordings. Recording several clips in a session does not create several riffs automatically. Assignment happens when the user chooses Make New Riff or Add to Existing Riff.

### Tablature

The conceptual hierarchy is:

```text
Riff
├── Details
├── Build
│   ├── Take 1 — audio
│   ├── Take 2 — video
│   └── Version with hammer-on — audio
└── Tablature
    ├── Tuning
    └── Sections
        └── Measures
            └── Notes at musical positions on strings

Group ← memberships → Riff
Jam session → unassigned recordings → new or existing Riff
```

Tablature stores musical structure, not screen coordinates. Each note identifies a string, fret, and position within a measure. Multiple strings at the same position form a chord. Exact duration and technique representation remain design work for the tablature milestone.

## Library and navigation

The latest direction uses a scrollable group folder strip above the riff collection. The strip includes group creation and selection. Selecting a group changes the riffs below it; an All Riffs scope provides the full library.

Latest and Browse remain useful library capabilities, rather than requiring three separate top-level screens. Final navigation controls will be settled through layout prototypes.

The library supports:

- Latest ordering and alphabetical ordering.
- Filtering by guitar type, tone, and optional key.
- Named groups and membership editing.
- Riff cards that identify the idea and provide access to its takes.
- Audio album presentation and video feed presentation.
- A gallery strip for jumping between riffs in the current scope.

### Riff cards and media modes

Audio presentation resembles an album: riff details above, with selectable recordings below. Video presentation supports portrait playback with upward swiping to the next riff. A title can be tapped to reveal or edit its description and details.

The group strip remains the organizational anchor above the riff view. The bottom gallery navigates riffs; the take selector navigates recordings within the selected riff. Those controls must be visually distinguishable.

**Proposed mixed-media behavior:** modes preserve the current group and filters. Audio mode offers audio takes; video mode offers video takes. A mixed riff can appear in both. A riff without compatible media gets an explicit empty state or is excluded by a separately indicated media filter. This choice still needs a prototype decision; silently hiding riffs merely because the layout changed would make the library confusing.

## Riff workspace and adaptive layout

Opening a riff creates an album-like workspace with its details, take selection, and selected media.

| Presentation | Intended arrangement |
| --- | --- |
| Wide or unfolded | Riff details and take selection on the left; selected player or recorder on the right |
| Compact | Details and take selection arranged vertically around the media area |
| Folded | Compact media presentation while browsing details or takes |
| Full screen | Selected player or recorder expands for focused use |

“Unfolded” means an expanded presentation with sufficient room; support for a particular foldable device is not a requirement.

Audio and video both support compact, expanded, and full-screen presentation. Selecting another take updates the media area. Add Take uses that area for recording. Layout transitions preserve playback position and must not restart or discard an active recording.

There is one selected recording and one media session, with several ways to present them. A view appearing or disappearing does not own the lifetime of the recording session.

## Capture flows

### Capture a new riff

1. Choose Quick Audio or Quick Video when no riff or session is active, or choose New Riff explicitly.
2. The selected format opens the appropriate recorder.
3. Record without completing metadata.
4. Save the first successful take; create the riff and attach Take 1.
5. Show the latest take and keep the riff active for further recording.
6. Add details whenever useful.

Creating the persisted riff on the first successful save is a proposed default that avoids empty library items after cancellation. The recorder may still use a temporary riff draft beforehand.

### Continue an active riff

1. The recorder shows the destination riff prominently.
2. Record another take in audio or video mode.
3. Save appends it to the build and selects the new take.
4. Repeat until New Riff or a different destination is chosen.

Opening an existing riff and choosing Add Take explicitly makes that riff the recording destination. Starting a new idea must be an obvious action; returning to the library should not silently create a different riff.

The exact persistence of the active destination across app launches is unresolved. During an active recording, destination changes must wait until the capture is stopped and saved or discarded.

### Capture with details

An optional detailed capture entry allows the user to enter a name, description, guitar type, tone, and key before recording. It uses the same save behavior as quick capture. Metadata remains optional.

### Record a jam session

1. Choose New Jam Session and optionally name it.
2. Record separate clips into the session.
3. Keep recording without deciding which riff each clip represents.
4. Review the clips later and assign each useful recording.

The confirmed motivation centers on audio jams. Allowing video in sessions is a proposed extension consistent with the recording model, not a settled requirement.

### Turn a jam recording into a riff

1. Select a recording and choose Make New Riff.
2. Optionally provide riff details.
3. Create the riff and transfer the whole recording into its build.
4. Make the destination clear and offer direct access to the new riff.

Add to Existing Riff instead opens a riff picker and transfers the selected recording into that riff. Other session recordings remain unassigned.

### Move a take between riffs

1. Open the take menu and choose Move to Riff.
2. Choose an existing destination or create a new riff.
3. Transfer the recording and update both builds.
4. Preserve the file, recording identity, and custom name.

Moving a take does not move the source riff’s description, tab, or group memberships. There is no trimming, splitting, or audio editing in this flow. Each jam clip is already a separate recording.

**Proposed safeguards:** offer Undo after a move, retain stable ordering, and show a clear result. If the source riff loses its last take, preserve its details and tablature until the user explicitly decides what to do with the empty riff.

## Playback behavior

The latest saved recording is the default riff preview. A newly saved take becomes selected. Users can select any earlier take without losing the rest of the build.

Audio presentation provides a player; video presentation provides its visual playback. Both should expose play/pause, position, duration, and seeking. Only one recording plays at a time. Moving to another feed item stops the previous item; automatic playback policy remains unresolved.

Switching presentation size preserves the current session. Starting a recording stops playback so the app does not accidentally record its own output.

Pinning a favorite take is a future option, not part of the current confirmed behavior.

## Guided tablature

Tablature is optional and can be added after capture. The intended editor uses manual placement with guides, rather than requiring pasted text.

1. Choose tuning at the left of the initial strings.
2. Choose the measure’s time signature and editing subdivision.
3. Create buildable sections containing measures.
4. Tap a slot on a string and enter a fret number.
5. Place simultaneous notes on other strings for chords.
6. Continue across measures and sections.

Time signature defines measure length. Subdivision defines selectable rhythmic positions, including regular divisions and eventually triplets. They must be separate concepts.

Rows adapt to screen width and note density. Four or five measures across is a wide-layout goal, not a fixed requirement on every screen. Smaller screens show fewer measures while retaining the same musical data. Selection guides and touch targets can be larger than the printed fret numbers.

Riff details appear above the tab. Recordings can be watched or heard alongside it, but synchronized highlighting and synthesized note playback are outside the initial scope.

The first editor should focus on tuning, sections, measures, fret placement, and chords. Durations, rests, ties, bends, slides, hammer-ons, and pull-offs require explicit follow-up decisions. Capo is a future optional field from the original discussion.

## Printable export

Export lays out the riff name, description, tuning, and tablature as a readable printable document. Guitar type, tone, and key can accompany the header when present.

Screen and print renderers share musical data but use different layout rules. Print needs readable spacing, complete measures, section headings, and sensible row and page breaks. It must not simply screenshot the editor.

**Proposed format:** PDF with a preview before sharing or printing. Paper sizes, repeated tuning labels, and detailed notation conventions remain open. Media-file export is a separate future decision.

## Storage and session integrity

The proposed foundation is local media files with SQLiteData storing metadata and relationships. Durable file references should resolve independently of temporary capture locations. No account or cloud service is required for the initial product.

A successful save means both the media file and recording metadata are durable. Failed saves should preserve recoverable captures and offer retry rather than showing a false success. Ownership moves should update source and destination together while leaving the media file intact.

The recorder must handle permissions, interruptions, unavailable camera or microphone, insufficient storage, and app lifecycle transitions. These cases should explain what happened and whether a recording was retained. Background audio capture and background video behavior need separate platform and product decisions.

Deletion and recovery policy must be designed before destructive actions ship. Removing a group membership is not deleting the riff. Deleting a riff, take, or session requires an explicit media-retention policy.

## Delivery stages

These stages are a proposed implementation sequence. All core product concepts above remain part of the design.

| Stage | Outcome |
| --- | --- |
| 1 Capture and build | New riff, audio/video capture, reliable save, multiple takes, rename, optional details, replay |
| 2 Library and workspace | Group strip, riff cards, memberships, sort/filter, album/feed modes, adaptive player and recorder |
| 3 Jam and reassignment | Session capture, Make New Riff, Add to Existing Riff, moves between riffs |
| 4 Tablature and print | Guided structured editor, responsive measures, printable export |

TCA and SQLiteData were discussed as learning and implementation candidates. Exact architecture, deployment targets, package boundaries, and file formats remain to be chosen. Development should teach the underlying state and relationship model while delivering usable slices.

## Decisions still needed

- Exact navigation and mixed-media behavior when changing view modes.
- Whether Latest means recently created or recently developed riffs.
- Whether the active capture destination persists after relaunch.
- Whether jam sessions support video immediately and retain assignment history.
- Take numbering after moves/deletions and duplicate default names.
- Empty-riff handling, deletion recovery, and media retention.
- Playback autoplay and background recording policy.
- Scope of rhythmic durations and techniques in the first tab editor.
- Whether tablature can eventually vary by take; current scope is one tab per riff.
- Print settings, media sharing, backups, and eventual sync.
- Visual styling, accessibility details, deployment targets, and architecture.

Setlists, practice history, a separate song model, custom saved browse views, advanced notation, media editing, and synthesized playback were early suggestions or future possibilities. They are not current core requirements. Groups can already be named after songs.

## Completion criteria for the core experience

- A user can capture without naming or categorizing first.
- Repeated saves append to the visible active riff and select the latest take.
- A riff can contain audio and video takes with custom names.
- A riff can belong to multiple groups without duplicate media.
- A jam recording can become a new riff or join an existing riff without editing its file.
- Moving a take preserves it and leaves unrelated source details intact.
- Folded, expanded, and full-screen layouts preserve media session state.
- The user can distinguish riff navigation from take selection.
- Save failures and interruptions never report a take as safely saved when it is not.
- Tab layout changes do not alter musical positions, and exported tab remains readable on paper.

## Reference and maintenance

The design consolidates the [shared RiffBook discussion](https://chatgpt.com/share/6ac58e50-06b8-83ea-9c2d-468ce7206952) and the follow-up decisions in this project chat. Later explicit user decisions supersede earlier suggestions. In particular, recording is central to the first usable product, visual guided tablature replaces the earlier text-editor suggestion, and jam sessions are separate from groups.

Update this file when product behavior changes. Update `PLAN.md` when implementation status or the next task changes. Resolve open decisions in their relevant sections rather than letting implementation silently establish a competing source of truth.
