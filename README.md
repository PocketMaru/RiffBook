# RiffBook

iOS application for recording and organizing musical ideas.

Open `RiffBook.xcworkspace` in Xcode. The workspace includes the app project
and the local `RiffBookCore` Swift package; the app links its library product.

```text
RiffBook/
├── RiffBook.xcworkspace
├── App/RiffBook/
│   ├── RiffBook.xcodeproj
│   ├── RiffBook/         # App entry point and assets
│   └── RiffBookCore/     # Local Swift package, starter view, and tests
├── DESIGN.md            # Product source of truth
└── PLAN.md              # Implementation status and next steps
```

The repository uses `main` and connects to
https://github.com/PocketMaru/RiffBook.git. The current minimum deployment
target is iOS 27.0, with Swift tools 6.4. RiffBookCore depends on TCA.

Build without signing:

```sh
xcodebuild -workspace RiffBook.xcworkspace -scheme RiffBook \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Track shared schemes and `Package.resolved`; exclude generated build output,
personal Xcode settings, and secrets. Keep local packages beside the Xcode project in `App/RiffBook/`.
The app currently displays the starter view; recording and persistence are
not implemented. The package test is a generated placeholder.
