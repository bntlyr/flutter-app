# Agents & Skills Guide

This document catalogs the active skills configured for this Flutter project (`flutter_app`), targeting Android and iOS with an immediate focus on Android.

---

## Skill #1: `flutter-add-integration-test`

- **Description**: Configures Flutter Driver for app interaction and converts MCP actions into permanent integration tests.
- **Location**: `.agents/skills/flutter-add-integration-test/SKILL.md`
- **Example Prompt**:
  > *"Add an integration test for the checkout flow in my app"*

### Overview & Workflow
1. Add dependencies:
   ```bash
   flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
   flutter pub add 'dev:flutter_test:{"sdk":"flutter"}'
   ```
2. Create test files under `integration_test/` (e.g., `integration_test/app_test.dart`).
3. Initialize the integration test binding:
   ```dart
   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
   ```
4. Run integration tests on Android device or emulator:
   ```bash
   flutter test integration_test/app_test.dart
   ```

---

## Skill #2: `flutter-setup-localization`

- **Description**: Adds localization support to your Flutter project using `flutter_localizations` and `intl`.
- **Location**: `.agents/skills/flutter-setup-localization/SKILL.md`
- **Example Prompt**:
  > *"Set up localization in my app"*

### Overview & Workflow
1. Add dependencies:
   ```bash
   flutter pub add flutter_localizations --sdk=flutter
   flutter pub add intl:^0.20.2
   ```
2. Enable code generation in `pubspec.yaml`:
   ```yaml
   flutter:
     generate: true
   ```
3. Configure `l10n.yaml` in the project root:
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   ```
4. Define string resources in `lib/l10n/app_en.arb` and import `AppLocalizations` in `MaterialApp`.

---

## Skill #3: `flutter-build-responsive-layout`

- **Description**: Uses `LayoutBuilder`, `MediaQuery`, or `Expanded`/`Flexible` to create a layout that adapts to different screen sizes.
- **Location**: `.agents/skills/flutter-build-responsive-layout/SKILL.md`
- **Example Prompt**:
  > *"Ensure that the checkout screen uses responsive layout"*

### Overview & Best Practices
- Use `LayoutBuilder` to make decisions based on parent constraints (`constraints.maxWidth`).
- Use `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context)` to prevent unnecessary rebuilds.
- Avoid device-type checking (phone vs. tablet); base layouts on available window width breakpoints (e.g., `< 600` compact mobile, `600..840` medium tablet, `> 840` expanded desktop/foldable).

---

## Skill #4: `dart-use-pattern-matching`

- **Description**: Refactors code to use Dart’s pattern matching language capabilities where appropriate (Dart 3+).
- **Location**: `.agents/skills/dart-use-pattern-matching/SKILL.md`
- **Example Prompt**:
  > *"Refactor my code so that it uses pattern matching where possible"*

### Overview & Key Features
- **Switch expressions**: Transform verbose `switch` statements and `if-else` cascades into concise expressions.
- **Destructuring**: Destructure maps, records, objects, and lists directly.
- **Guards**: Apply `when` clauses to patterns.
- **Exhaustiveness checking**: Ensure sealed classes and enums cover all variations without runtime fallback gaps.

---

## Skill #5: `dart-collect-coverage`

- **Description**: Uses the coverage package to collect unit test coverage and generate an LCOV report.
- **Location**: `.agents/skills/dart-collect-coverage/SKILL.md`
- **Example Prompt**:
  > *"Collect test coverage for my project"*

### Overview & Workflow
1. Run Flutter tests with coverage collection:
   ```bash
   flutter test --coverage
   ```
2. LCOV data is output to `coverage/lcov.info`.
3. To filter and format into HTML reports:
   ```bash
   # Using lcov genhtml
   genhtml coverage/lcov.info -o coverage/html
   ```

---

## Platform Support Status

- **Android**: Primary focus. Project configured with Android Gradle Plugin & Kotlin (JDK 21 compatible, targeting Java 17). Ready for Android development and testing once Android SDK / emulator / device is connected.
- **iOS**: Configured and available in `ios/` directory (Xcode 26 ready).

---

## Project Design System & Theming Guidelines

### 1. Mandatory Brand Palette
All widgets, screens, and features in this application must strictly adhere to the centralized design tokens defined in `lib/core/theme/`:
- **Primary**: `#55AAAA` (`0xFF55AAAA`) — Main actions, primary buttons, active states, app bars.
- **Gray**: `#303030` (`0xFF303030`) — Neutral dark accents, secondary button borders, dark surfaces.
- **Main Black**: `#000000DE` (`0xDE000000`) — 87% alpha high-emphasis typography for headers, titles, and body text.

### 2. Widget Styling Invariants
- **Never Hardcode Colors**: Do not use `Color(0xFF55AAAA)` directly in UI views. Always use `Theme.of(context).colorScheme.primary`, `Theme.of(context).textTheme`, or `context.customColors`.
- **Material 3 Component Standard**: Rely on Flutter Material 3 widgets (`FilledButton`, `ElevatedButton`, `OutlinedButton`, `TextField`, `Card`, `AppBar`), which automatically inherit the centralized theme configured in `lib/core/theme/app_theme.dart`.

### 3. Scroll Physics Standard
- To prevent Android 12+ elastic overscroll distortion from warping component cards, always maintain `overscroll: false` and `BouncingScrollPhysics()` on `MaterialApp.scrollBehavior` and scrollable containers.

---

## Android Toolchain Runbook

- **License Status Issue**: If `flutter doctor` reports `Android license status unknown` with Android SDK 36+, ensure the `cmdline-tools/latest/bin/sdkmanager` script prints `All SDK package licenses accepted.` when called with `--licenses`.
- **Emulator Userdata Space**: Android 17 (API 37) virtual devices require ~7.4 GB host space for the initial userdata partition. Use `brew cleanup -s` or unmount unused DMGs if host disk space is constrained.

