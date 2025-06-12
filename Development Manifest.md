## 🧭 StreamKeys Dev Manifesto

### 🎯 Purpose

**StreamKeys** is a cross-platform application that allows configuring action buttons on two interfaces:

* **Grid Deck** — a mobile and web app that, over a local Wi-Fi network, receives configured buttons and triggers actions on a Windows PC via a companion Windows application;
* **Keyboard Deck** — works with connected keyboards combined with HID Macros to control actions on the PC.

The goal is to create a simple, fast, and reliable StreamDeck alternative for streamers that works without complex setup or expensive hardware.

---

### 📐 Architecture

* BLoC is used as the main state management pattern with clear handling of states (loading, success, error) and centralized error management.

* The structure follows a feature-first approach: each feature contains its own BLoC, data layer (models, repositories, services), presentation (widgets, screens), and other related components. To avoid tight coupling between features, well-defined interfaces and contracts are applied.

* Instead of using global variables, a service locator (e.g., get_it) is employed to centrally manage dependencies, improving testability and simplifying scaling.

* Clean Architecture principles are followed: business logic is fully isolated from the UI, dependencies are minimal and controlled via interfaces.

* The codebase is split by platforms: inside the lib folder, there are separate directories for Android, Web, Desktop, as well as a common folder for reusable widgets and utilities (common/widgets, common/utils). Maximizing shared code minimizes duplication.

* For data handling, services and repositories abstract access to Windows system APIs, and implement caching and data synchronization where needed (local database, Shared Preferences).

* Testability is emphasized: each layer and feature is covered by unit and integration tests. Thanks to interface abstraction, approximately 80% code coverage is achieved.

### Example Project Structure

```plaintext
lib/
├── android/
│   ├── features/
│   │   ├── feature-one/
│   │   │   ├── bloc/
│   │   │   │   └── feature_one_bloc.dart           # Business logic component (BLoC)
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── feature_one_model.dart      # Data models
│   │   │   │   ├── repositories/
│   │   │   │   │   └── feature_one_repository.dart # Data access and abstraction
│   │   │   │   └── services/
│   │   │   │       └── feature_one_service.dart    # External APIs or platform-specific services
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── feature_one_screen.dart     # UI screens
│   │   │   │   └── widgets/
│   │   │   │       └── feature_one_widget.dart     # UI widgets
│   │   │   └── feature_one_contract.dart           # Interfaces and contracts for abstraction
│   │   └── ...
│   ├── android_main.dart                           # Android entry point
│   └── ...
├── desktop/
│   ├── features/
│   │   ├── feature-one/
│   │   │   └── ... (similar structure as android)
│   │   └── ...
│   ├── desktop_main.dart                           # Desktop entry point
│   └── ...
├── web/
│   ├── features/
│   │   ├── feature-one/
│   │   │   └── ... (similar structure as android)
│   │   └── ...
│   ├── web_main.dart                               # Web entry point
│   └── ...
├── common/
│   ├── widgets/                                    # Reusable widgets across features and platforms
│   ├── utils/                                      # Utility functions and helpers
│   └── ...
├── core/
│   ├── constants/                                  # App-wide constants (colors, spacing, radius, etc.)
│   |   └── ...
│   ├── theme/                                      # Theme setup and custom styling components
|   │   ├── theme.dart
|   │   └── components/                             # Custom theme-related styles and components
│   └── ...
├── main.dart                                       # Optional global entry or shared logic
└── service_locator.dart                            # Dependency injection setup
```

---

### 🧱 Style convention

* Style: follow `dart format lib` strictly, use strict lints from lints.yaml.
* File naming: `snake_case` for files.
* Class and widget naming: `PascalCase`.
* No more than `one class or widget` per file.
* Use meaningful and clear names avoiding abbreviations.
* Keep code modular and maintainable by separating concerns per feature.

---

### 📦 Dependencies

* Add a new dependency only if it is critically needed or significantly speeds up development.
* All third-party packages must be added via `pubspec.yaml` with a comment explaining their purpose.

---

### 🚀 CI/CD (optional)

* Automatic formatting and test runs before every merge.
* Builds for Android, iOS, and Web.

---

### 📝 Documentation

* Every public class/method must have a comment.
* README.md should always describe the current state of the application.

---

### 🔧 Commit Convention

* Git commits follow the format: `type(scope): message`
  Example: `feat(ui): add stream key generator`

* Basic commit types:

  * `feat` — a new feature
  * `fix` — a bug fix
  * `docs` — documentation only changes
  * `style` — formatting, missing semicolons, etc; no code change
  * `refactor` — code change that neither fixes a bug nor adds a feature
  * `test` — adding missing tests or correcting existing tests
  * `chore` — changes to build process or auxiliary tools and libraries

* More about this convention: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
