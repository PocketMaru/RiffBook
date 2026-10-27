# RiffBook product design

Version 2 • October 13, 2026

RiffBook is a private musical idea library. Capture an idea quickly through audio or video, develop it through multiple takes, organize it into songs, and optionally document it with guided tablature. The experience should make ideas memorable and easy to return to without interrupting playing.

This is the product source of truth. `PLAN.md` tracks implementation progress and the next task. This design describes intended behavior; it does not imply that features are implemented. Explicit requirements are separated from proposed defaults and open decisions below.

## Core principles

- Capture first, complete details later. Music theory and forms never gate recording.
- A riff is an idea. A recording is one take or variation of that idea.
- Keep developing the active riff until the user chooses New Riff or another capture destination.
- Jam sessions collect recordings before the user decides which ideas they belong to.
- Songs organize riffs without duplicating them.
- Presentation changes preserve the selected media and session state.
- Save recordings reliably and make their destination visible.

## Product vocabulary

| Concept | Meaning | Relationship |
| --- | --- | --- |
| Recording | One complete audio or video capture | Belongs to a riff or an unassigned jam session |
| Riff | A musical idea with details and a build of recordings | Can belong to multiple songs |
| Build | The ordered collection of takes developing a riff | Contains recording models, not stitched media |
| Song | A named song assembled from riff memberships | References riffs; a riff can appear in several songs |
| Jam session | A holding place for captures that have not become riffs | Recordings can become new riffs or join existing ones |
| View mode | Changes the presentation, such as audio album or video feed | Does not itself change membership |
| Filter | Restricts results by metadata or media availability | Does not move or modify content |
| Tablature | Optional structured instructions for playing a riff | Belongs to the riff |

Songs are the user-facing name for the former groups: collections of established
riffs used to build songs. Sessions hold recordings waiting to be assigned to
riffs. A song is not a session and does not own copies of riff media.

## Information model

### Riff

| Property | Purpose |
| --- | --- |
| Identity | Stable reference independent of its name |
| Name | User-editable title; capture may precede naming |
| Description | Optional context, reminders, or explanation |
| Instrument | Optional instrument label shown on riff cards; supported values remain open |
| Guitar type | Optional electric, acoustic, or nylon classification |
| Tone | Optional clean or distortion classification |
| Musical key | Optional metadata retained from the original browse concept |
| Tuning | Optional instrument tuning, separate from musical key; e.g. Standard, Drop D, Drop C, or custom |
| Build | Ordered recordings with automatic or custom take names |
| Favorite take | Optional recording reference used for default riff-card playback |
| Tablature | Optional tuning, sections, measures, and notes |
| Song memberships | Links to any number of songs |
| Created and updated dates | Support library ordering |

Guitar type and tone are separate fields. An electric riff can be clean. A riff may contain both audio and video; its first capture determines its initial recording mode, not a permanent media classification.

Tuning is riff metadata available independently of tablature. It can remain unset
so it never gates capture. A preset picker with custom entry is the proposed
input; the preset list and structured representation remain to be decided.
Musical key describes the music, while tuning describes the instrument setup.

### Recording

A recording has a stable identity, name, media type, file reference, creation date, and position within its destination. Duration and a video thumbnail or audio visual representation support presentation.

Names default to Take 1, Take 2, Take 3, and so on within a riff. The user can rename any take, for example “Version with hammer-on” or “Slower version.” Renaming does not change identity or ordering.

Recording creation requires a name string in its contract. An empty string
requests automatic Take N naming from the repository; nonempty input supplies
the custom name. The repository assigns identity and creation time when saving.

**Proposed ownership rule:** each recording has one current owner: a riff or a jam session. Moving it changes ownership without duplicating or editing the file. An optional origin-session reference can preserve provenance later, but a session history policy is not yet settled.

The `build` property is the app-facing collection. Storage can represent it through related recording rows rather than placing all recordings inside a single database field.

### Song

A song has an identity, user-chosen name, optional musical key, and memberships
referencing riffs. A riff can belong to multiple songs. Adding a riff creates
membership, not a duplicate riff or media file. Removing membership leaves the
riff and recordings intact. Additional song metadata and ordering of riffs
within a song remain open decisions.

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

Song ← memberships → Riff
Jam session → unassigned recordings → new or existing Riff
```

Tablature stores musical structure, not screen coordinates. Each note identifies a string, fret, and position within a measure. Multiple strings at the same position form a chord. Exact duration and technique representation remain design work for the tablature milestone.

## Library and navigation

### Riff library (launch screen)

The app opens to riff cards in rows of two. Restore the user's last saved
filter/sort selection; without one, show most recent first. “Most recent” is
provisionally the last successful recording save; whether metadata edits also
count remains open. Cards show name, instrument, key, clean/distortion tone,
song memberships, and separate audio/video recording counts when available.
Missing optional metadata should not block capture or produce invented values.

The top-left toolbar action opens account information. The top-right plus (or
future custom capture icon) starts a new riff or session, followed by audio or
video selection. The chosen recorder opens immediately with a temporary draft
destination. Actual authentication, account services, and cloud sync are not
implied by the account screen.

Songs and Sessions must be reachable from the main library. A bottom navigation
with Riffs, Build, Songs, and Sessions is a concept proposal, not a finalized
navigation decision. The account button stays in the top-left toolbar.

### Song-building workspace (proposed label: Build)

A horizontal song strip stays at the top, with an add-song action at its right.
Creating a song allows a name and optional key; other fields remain undecided.
The lower area initially shows a horizontal scroll of rich riff cards.

Selecting a riff opens its full details in the lower area while keeping the song
strip visible. Tapping a song while a riff is selected prompts to add that riff
to the song. Confirming creates membership; canceling changes nothing. If the
riff is already included, show that state and avoid duplicate membership.
Without a selected riff, a song can open its contained riffs.

“Build” is a proposed screen label. The existing riff build still means the
ordered takes inside one riff; those are separate concepts and need distinct
labels in the final interface.

### Songs library and song detail

Songs are displayed as song cards. Selecting one opens a riff view scoped to
that song, with access to its riff details and recordings. This library is for
browsing songs; the Build workspace is for assigning riffs to songs.

### Sessions library and session detail

Sessions are reachable from the main view. Selecting a session shows its
recordings. Selecting a recording opens playback and a Create Riff action.
This converts the selected whole recording into the first take of a riff;
other recordings in the session remain unchanged. Add to Existing Riff remains
part of the previously described assignment flow.

### Media presentation

Audio player, video player, and selectable takes belong in riff details. Audio
and video counts are distinct from song memberships. A riff may contain both
media types; choosing audio or video for its first draft does not permanently
classify the riff. The earlier album/feed direction remains a later presentation
option; it does not replace the newly confirmed two-column launch library.

## Visual concept direction

Dark mode is dominant: near-black canvas, elevated charcoal surfaces, clear
white primary text, muted secondary text, and an Apple Music-inspired rose/red
accent for capture and navigation. Artwork-like riff and song cards provide
visual identity without requiring uploaded cover art. These are provisional
visual choices, not final design-system tokens.

The initial concept covers the riff library, capture destination/media picker,
audio and video draft recorders, riff detail/takes, song-building workspace,
assignment confirmation, new-song form, songs library, song's riffs, sessions
library, session recordings, recording-to-riff conversion, and account information.
Account contents, exact navigation, empty/error states, and advanced tablature
remain follow-up design work. The incoming design system will determine final
components, tokens, spacing, and appearance. Do not integrate it until supplied.

## Riff artwork and playback animation

After the first recording saves successfully, generate riff artwork from a fixed
segment at the beginning of that recording. Use that segment as recorded,
including opening silence; do not automatically search for louder content.
The exact segment duration and bar count remain open.

Pair the waveform with a randomly selected background from the concept palette.
Persist the background identity and derived waveform values so the resting card
is consistent across appearances and launches. The first recording establishes
this resting artwork; later recordings do not automatically replace it.

Every riff card/box that supports Play must use the same playback-aware artwork
behavior, including the riff library, song-building workspace, song-scoped riff
view, and riff detail. When Play is tapped, animate the waveform using current levels
from the actual recording being played. Those values must follow the playback
position, including seeking; they are not microphone input or random animation.
Keep the background identity stable. This animation is transient and does not
rewrite the stored resting artwork. On Pause, retain the waveform at the paused playback position. Keep it linked
to the player timeline: seeking while paused updates the visual to that position,
and resuming continues from there. Paused audio does not generate new live
samples; derive the paused-position visual from cached analysis or file data.
Stop/end behavior remains a separate presentation decision.

Audio amplitude or RMS values can be mapped into visible bar heights; exact
scaling, smoothing, and reduced-motion presentation remain implementation work.
The same behavior can use the audio track of a video recording. Live playback
artwork is intended behavior, not implemented in the current concept or app.

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

1. Use the top-right capture action, choose New Riff, then Audio or Video.
2. The selected format opens the appropriate recorder.
3. Record without completing metadata.
4. Save the first successful take; create the riff and attach Take 1.
5. Show the latest take and keep the riff active for further recording.
6. Add details whenever useful.

The selected media opens with a temporary riff draft. Persisting the riff on the first successful save remains the proposed default; canceling a draft should not create an empty library card.

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

The capture picker offers Audio or Video for a new session as well as a new riff. Both must follow the same recording integrity rules.

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

Moving a take does not move the source riff’s description, tab, or song memberships. There is no trimming, splitting, or audio editing in this flow. Each jam clip is already a separate recording.

**Proposed safeguards:** offer Undo after a move, retain stable ordering, and show a clear result. If the source riff loses its last take, preserve its details and tablature until the user explicitly decides what to do with the empty riff.

## Playback behavior

A riff supports one optional favorite take, selected from its recordings. The
favorite is the default recording for Play from any riff card/box when present,
including riffs with multiple takes. Choosing a new favorite replaces the previous
favorite. It does not reorder, duplicate, or move recordings.

Without a favorite, Play defaults to the latest successfully saved recording.
Saving another take selects it for immediate review inside the active riff, but
does not replace an existing favorite. Users can explicitly play any other take;
card artwork follows the actual playing take, not always the favorite. Paused
playback resumes the same take/position rather than restarting the default.

Persist the favorite recording reference with the riff and ensure it belongs to
that riff. If that take is moved or deleted, clear its favorite reference and
fall back to the latest remaining take; exact deletion retention policy remains
open. Changing favorite during playback is proposed to affect the next fresh
card playback, rather than interrupt the current take.

Audio presentation provides a player; video presentation provides its visual playback. Both should expose play/pause, position, duration, and seeking. Only one recording plays at a time. Moving to another feed item stops the previous item; automatic playback policy remains unresolved.

Switching presentation size preserves the current session. Starting a recording stops playback so the app does not accidentally record its own output.

Favorite take selection is confirmed scope. It chooses default playback, while
the first recording still establishes the riff's resting artwork.

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

Deletion and recovery policy must be designed before destructive actions ship. Removing a song membership is not deleting the riff. Deleting a riff, take, or session requires an explicit media-retention policy.

## Delivery stages

These stages are a proposed implementation sequence. All core product concepts above remain part of the design.

| Stage | Outcome |
| --- | --- |
| 1 Capture and build | New riff, audio/video capture, reliable save, multiple takes, rename, optional details, replay |
| 2 Library and workspace | Song strip, riff cards, memberships, sort/filter, album/feed modes, adaptive player and recorder |
| 3 Jam and reassignment | Session capture, Make New Riff, Add to Existing Riff, moves between riffs |
| 4 Tablature and print | Guided structured editor, responsive measures, printable export |

TCA and SQLiteData were discussed as learning and implementation candidates. The current scaffold uses TCA, Swift tools 6.4, and an iOS 27.0 minimum. Detailed architecture, package boundaries, and file formats remain to be chosen. Development should teach the underlying state and relationship model while delivering usable slices.

## Decisions still needed

- Exact navigation and the final name/access point for the song-building workspace.
- Mixed-media behavior for future album/feed presentation.
- Whether Latest means recently created or recently developed riffs.
- Whether the active capture destination persists after relaunch.
- Session assignment history after converting or moving recordings.
- Take numbering after moves/deletions and duplicate default names.
- Empty-riff handling, deletion recovery, and media retention.
- Playback autoplay and background recording policy.
- Scope of rhythmic durations and techniques in the first tab editor.
- Whether tablature can eventually vary by take; current scope is one tab per riff.
- Print settings, media sharing, backups, and eventual sync.
- Visual styling, accessibility details, deployment targets, and architecture.

Setlists, practice history, custom saved browse views, advanced notation, media editing, and synthesized playback were early suggestions or future possibilities. They are not current core requirements. Songs now explicitly replace the former group terminology.

## Completion criteria for the core experience

- A user can capture without naming or categorizing first.
- Repeated saves append to the visible active riff and select the latest take.
- A riff can contain audio and video takes with custom names.
- A favorite take controls fresh riff-card playback across all riff views.
- All playable riff cards follow the actual playing take and retain synchronized
  waveform state while paused, including paused seeking.
- A riff can belong to multiple songs without duplicate media.
- Launch shows two-column riff cards with restored filter/sort or most-recent default.
- Song assignment keeps the selected riff and song strip visible and requires confirmation.
- Songs open their contained riffs; sessions open their recordings and offer Create Riff.
- A jam recording can become a new riff or join an existing riff without editing its file.
- Moving a take preserves it and leaves unrelated source details intact.
- Folded, expanded, and full-screen layouts preserve media session state.
- The user can distinguish riff navigation from take selection.
- Save failures and interruptions never report a take as safely saved when it is not.
- Tab layout changes do not alter musical positions, and exported tab remains readable on paper.

## Concept sharing

The hosted screen concept uses a shared passcode checked server-side before
serving the preview. Keep the existing URL stable across updates. This gate
belongs to the design preview and does not define authentication for the app.

## Reference and maintenance

The design consolidates the [shared RiffBook discussion](https://chatgpt.com/share/6ac58e50-06b8-83ea-9c2d-468ce7206952) and the follow-up decisions in this project chat. Later explicit user decisions supersede earlier suggestions. In particular, recording is central to the first usable product, visual guided tablature replaces the earlier text-editor suggestion, and jam sessions are separate from songs.

Update this file when product behavior changes. Update `PLAN.md` when implementation status or the next task changes. Resolve open decisions in their relevant sections rather than letting implementation silently establish a competing source of truth.

### Current theme resource implementation

The interactive screen concept now explores a floating liquid-glass tab bar and
a foldable-phone opening slider, moving between compact and expanded layouts.
This is visual prototype direction; device geometry is illustrative and does
not establish hardware specifications or production platform API behavior.

RiffBook Midnight's 26 semantic colors are app-owned named assets in the
RiffBookCore package. The theme looks them up through Bundle.module. This is a
fixed dark palette; future light variants require explicit design choices.

### Simulator-informed foldable concept

The preview models distinct outer and inner displays with a book-style hinge,
including partially open poses. Glass navigation is a trailing vertical rail
under the status/camera area, informed by Apple's iOS 27.1 guidance and the
local iPhone Duo simulator. This supersedes the earlier width-stretch prototype;
production Swift adaptation remains pending.
