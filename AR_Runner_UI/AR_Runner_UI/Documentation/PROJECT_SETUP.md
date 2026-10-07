# AR Runner — Project Setup

## Project location

Open `AR_Runner_UI/AR_Runner_UI.xcodeproj` in Xcode.

The application source is organized by responsibility:

```text
AR_Runner_UI/
├── App/                  # App entry point and top-level navigation
├── Core/                 # Shared UI, location, and Unity integration
├── Features/             # User-facing screens grouped by feature
├── Resources/            # Asset catalogs and other bundled resources
└── Documentation/        # Project setup and development notes
```

## Running the app

1. Open the Xcode project.
2. Select an iPhone simulator or a connected iPhone.
3. Choose the `AR_Runner_UI` scheme.
4. Build and run.

For a physical iPhone, configure Signing & Capabilities with a development team and a unique bundle identifier.

## Unity as a Library

Unity integration is currently represented by `Core/Unity/UnityBridge.swift`.
When the Unity export is ready:

1. Build the Unity project for iOS using Unity as a Library.
2. Merge the Unity export into the Xcode project.
3. Connect the exported Unity framework to the app target.
4. Enable the Unity framework calls in `UnityBridge.swift`.

## Required permissions and capabilities

- Location When In Use, with the usage description configured in the app target.
- Motion & Fitness when motion tracking is enabled.
- Bluetooth and External Accessory when device communication is enabled.
- HealthKit when heart-rate data is enabled.
- Background Location Updates only if background route recording is required.

No external Swift Package Manager dependency is required for the current MVP.
