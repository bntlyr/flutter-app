# PayrollNeo — Employee Self-Service (ESS) Portal

[![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84?logo=android)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red)](#)

A mobile-first Employee Self-Service (ESS) application built with Flutter & Material 3. **PayrollNeo** empowers employees to manage attendance punches, file HR requests, review daily time records (DTR), inspect comprehensive payroll advice slips, and monitor personal employment records.

---

## Table of Contents

- [Application Overview & Features](#application-overview--features)
- [System Requirements & What to Install](#system-requirements--what-to-install)
- [Quick Start / First-Time Setup](#quick-start--first-time-setup)
- [One-Shot Runner (`run.sh`)](#one-shot-runner-runsh)
- [Running the Application](#running-the-application)
- [GraphQL Codegen Scripts](#graphql-codegen-scripts)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Project Architecture & Structure](#project-architecture--structure)
- [Design System & UI Invariants](#design-system--ui-invariants)
- [Guidelines for Developers & AI Agents](#guidelines-for-developers--ai-agents)

---

## Application Overview & Features

PayrollNeo features 6 core tabs accessible via standard Material 3 bottom navigation:

1. **Employee Portal (`PortalScreen`)**:
   - Real-time attendance state and biometric punch simulation (**Time In** / **Time Out**).
   - Dynamic attendance alerts (cut-off reminders, schedule notes).
   - High-level payroll summary with net pay peek.
2. **Daily Time Record (`DtrScreen`)**:
   - Cutoff regular hours, overtime, tardiness, and undertime metrics.
   - Dual-view presentation: High-visibility mobile cards with toggleable `DataTable` view.
3. **Request Filing (`RequestScreen`)**:
   - 2-column grid layout for single-page visibility without scrolling.
   - Filing workflows:
     - **Leave Application** (Vacation, Sick, Emergency, Bereavement).
     - **Timelogs Correction** (Missed time-in/out, biometric terminal glitch).
     - **Allowance & Reimbursement** (Project travel, onsite per diem).
     - **Overtime (OT) Request** (Pre-approval & actual extended hours).
     - **Day Off Work** (Rest day & holiday work authorization).
     - **Reshift / Shift Swap** (Roster & schedule change).
4. **Request Status Tracker (`StatusScreen`)**:
   - Interactive filtering by status chip (**All**, **Pending**, **Approved**, **Rejected**, **Cancelled**).
   - In-app request cancellation for pending items.
5. **Payslip & Advice (`PayslipScreen`)**:
   - Confidential net take-home pay hero display with toggleable visibility.
   - 8-category payroll breakdown (Basic Pay, Overtime, Night Differential, Rest Day/Holiday, Allowances, De Minimis, Tax & Government Statutory Deductions, Loans & Offsets).
   - Dual-view presentation (digital receipt card and breakdown table).
6. **Personal Profile (`PersonalScreen`)**:
   - Employee identification, contact information, and department assignment.
   - Leave credit balance tracker (Vacation, Sick, Emergency).
   - Government statutory numbers (SSS, PhilHealth, Pag-IBIG, TIN).
   - Active loan ledger and recurring payroll deductions.

---

## System Requirements & What to Install

Before setting up the repository, ensure your environment has the following installed:

### 1. Flutter SDK & Dart
- **Flutter SDK**: `^3.13.2` or later (stable channel recommended).
  - Download from: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
  - Verify installation:
    ```bash
    flutter --version
    ```

### 2. Java Development Kit (JDK)
- **JDK 17 or JDK 21** (JDK 17 target compatibility is configured in Gradle).
  - Recommended: Eclipse Temurin OpenJDK 17 or 21 (`brew install --cask temurin@17` on macOS).
  - Set `JAVA_HOME` in your environment (e.g. `export JAVA_HOME=$(/usr/libexec/java_home -v 17)`).

### 3. Android Development Toolchain (Primary Target)
- **Android Studio**: Ladybug / Meerkat or newer.
- **Android SDK Components** (via Android Studio SDK Manager):
  - Android SDK Command-line Tools (`cmdline-tools;latest`)
  - Android SDK Build-Tools (version `34.0.0` or later)
  - Android SDK Platform `android-34` or `android-35`
  - Android Emulator with an API 33+ system image (e.g. Pixel 7 / Pixel 8 image)

### 4. iOS Development (macOS only, optional)
- **Xcode**: 15+ or 16+ with iOS Simulator installed.
- **CocoaPods**: `gem install cocoapods` or Homebrew `brew install cocoapods`.

---

## Quick Start / First-Time Setup

Run the following commands from your terminal in the repository root directory:

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd flutter-app
```

### Step 2: Validate Environment Health
```bash
flutter doctor
```
> [!NOTE]
> If `flutter doctor` flags Android licenses, accept them with:
> ```bash
> flutter doctor --android-licenses
> ```

### Step 3: Install Flutter Dependencies
```bash
flutter pub get
```

---

## One-Shot Runner (`run.sh`)

Whenever you make changes to the app or backend schema (`npm run dev` in `prod/api-server`), use **`./run.sh`**. It automates the full clean, fetch, codegen, and run cycle in a single command:

```bash
# Launch on default connected device/emulator
./run.sh

# Or launch on a specific device target
./run.sh -d emulator-5554
./run.sh -d <real_device_id>
```

**What `./run.sh` does in sequence:**
1. **Clean**: Wipes build cache, `__generated__/` directories, `*.graphql.dart`, and `schema.graphql`.
2. **Fetch Schema**: Introspects live GraphQL schema from `$GRAPHQL_URL` (default `http://localhost:4002/graphql`).
3. **Codegen**: Compiles strongly-typed Dart queries and mutations via `dart run build_runner build`.
4. **Launch**: Resolves host machine's local Wi-Fi IPv4 address (e.g. `http://192.168.1.153:4002`) and runs `flutter run --dart-define=API_BASE_URL="http://<IP>:4002" "$@"` so real devices connect immediately.

---

## GraphQL Codegen Scripts

If you need to run specific steps manually without launching Flutter:

### Clean Codegen & Schema
Deletes all generated files, `__generated__/` folders, and `schema.graphql`:
```bash
./clean_codegen.sh
```

### Fetch Schema & Regenerate Dart Classes
Runs the clean step, pulls fresh schema from `http://localhost:4002/graphql`, and compiles Dart code:
```bash
./generate.sh
```

### Automatic Execution in Android Studio (Before Launch)
To make Android Studio run `generate.sh` automatically every time you click the green **▶ Run** button:
1. Go to **Run** → **Edit Configurations...**
2. Select **main.dart**.
3. Under **Before launch**, click **`+`** → **Run External Tool**.
4. Set Program: `/bin/bash`, Arguments: `generate.sh`, Working directory: `$ProjectFileDir$`.
5. Click **OK** → **Apply**.

---

## Running the Application

### List Available Devices and Emulators
```bash
flutter devices
flutter emulators
```

### Launch on an Android Emulator
```bash
# Launch your emulator (e.g., Pixel_8_API_34)
flutter emulators --launch Pixel_8_API_34

# Run the app in debug mode with hot reload
flutter run
```

### Run on a Specific Device Target
```bash
flutter run -d <device-id>
```

### Build Release Packages
```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle (AAB for Google Play)
flutter build appbundle --release

# Build iOS Archive (macOS only)
flutter build ios --release
```

---

## Testing & Quality Assurance

PayrollNeo has a complete suite of unit, model, and component widget tests:

```bash
# Run all tests
flutter test

# Run tests with code coverage collection
flutter test --coverage

# Run static analysis and linting checks
dart analyze
```

---

## Project Architecture & Structure

The codebase is organized into a clean layered architecture:

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Brand palette (#55AAAA, #303030, #000000DE)
│   │   ├── app_theme.dart          # Light and dark ThemeData configurations
│   │   └── app_text_theme.dart     # Typography styles and weights
│   └── utils/
│       └── app_formatters.dart     # Currency (₱), date, time, and number formatters
├── data/
│   ├── mock/
│   │   ├── mock_attendance_data.dart # Attendance logs and punch history
│   │   ├── mock_payslip_data.dart    # Cutoff payslips and 8-category breakdowns
│   │   ├── mock_profile_data.dart    # Employee profiles and balances
│   │   └── mock_requests_data.dart   # Reactive user requests repository
│   └── models/
│       ├── attendance_model.dart
│       ├── payslip_model.dart
│       ├── profile_model.dart
│       └── request_model.dart
├── ui/
│   ├── features/
│   │   ├── dtr/                    # Daily Time Record & punch summaries
│   │   ├── payslip/                # Payslip review & breakdown views
│   │   ├── personal/               # Employee identity, balances, statutory IDs
│   │   ├── portal/                 # Home dashboard, punch buttons, alerts
│   │   ├── request/                # 2-column request filing grid & bottom sheets
│   │   ├── splash/                 # Startup splash screen
│   │   └── status/                 # Request status tracker & filters
│   └── shared/
│       ├── metric_card.dart        # Reusable metric card with icons and trends
│       ├── receipt_card.dart       # Digital jagged receipt card
│       ├── section_header.dart     # Consistent module section titles
│       └── status_badge.dart       # Status pill badges (Pending, Approved, etc.)
└── main.dart                       # Entry point and bottom navigation routing
```

---

## Design System & UI Invariants

All new features and modifications must follow these mandatory design tokens and rules:

1. **Brand Palette**:
   - **Primary**: `#55AAAA` (`0xFF55AAAA`) — Main actions, primary buttons, active icons, app bars.
   - **Neutral Dark / Surface**: `#303030` (`0xFF303030`) — Card headers, secondary surfaces, filing date containers.
   - **High-Emphasis Typography**: `#000000DE` (`0xDE000000`) — Primary headers, body text (87% alpha).
2. **Never Hardcode Colors in Views**:
   - Always reference colors via `Theme.of(context).colorScheme.primary`, `AppColors.<color>`, or `Theme.of(context).textTheme`.
3. **Scroll Physics**:
   - Always set `BouncingScrollPhysics()` and `overscroll: false` on scrollables and `MaterialApp.scrollBehavior` to avoid Android 12+ elastic card distortion.
4. **No "Premium" Badges**:
   - All employee features, rest-day compensation, and portals are standard corporate capabilities. Never use paywall or "Premium" tags.
5. **Mobile-First Overflow Guardrails**:
   - Wrap variable-length text (`Row` children) in `Expanded` or `Flexible` with `overflow: TextOverflow.ellipsis`.

---

## Guidelines for Developers & AI Agents

When implementing tasks or contributing code:

- **Follow Active Skills**: Consult `.agents/skills/` (e.g., `flutter-build-responsive-layout`, `flutter-add-widget-test`, `dart-use-pattern-matching`).
- **Preserve Documentation Integrity**: Do not overwrite or remove unrelated comments.
- **Run Verification Before Completing**:
  - Run `dart analyze` to ensure 0 lint errors.
  - Run `flutter test` to ensure all regression and widget tests pass.
- **Package Publishing Guardrail**:
  - Never run automated version bumps or publishing commands (`npm publish`, `flutter pub publish`). Manual action by repository owners is required.
