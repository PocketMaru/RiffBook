# RiffBook project plan

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
  including RiffBookCore and TCA. No commit or push was made.
- Product design is documented in `DESIGN.md`, including riffs, takes, groups,
  jam sessions, media presentation, guided tablature, and printable export.

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

Design the initial models and reducer
flow for the first capture/save/replay slice using `DESIGN.md`.

## Later

- Settle package boundaries and architecture as the first functional slice develops.
- Replace the generated placeholder test with meaningful behavior tests as logic is added.
- Commit and publish the repaired project when requested.
