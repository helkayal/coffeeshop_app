# Coffee Shop App Project Instructions

## Overview
This file contains project-specific guidelines, conventions, and architectural rules for the `coffeeshop_app`. These rules override the global instructions when working within this specific workspace.

## Tech Stack

- **Flutter** (Dart 3.10+)
- **State Management:** flutter_bloc / Cubit
- **Local Storage:** Hive (hive_flutter)
- **Localization:** easy_localization

## Clean code always

- Keep code clean, readable, and maintainable.
- Prefer clarity over cleverness.

## Small files and functions

- Files and functions must stay small and focused.
- Avoid large classes or overly complex files.
- files should have less than 100 line of code if possible.

## Comments only when necessary

- Add comments only when the intent is not obvious.
- Do not add redundant or obvious comments.

## Clean Architecture discipline (strict)

- Follow Clean Architecture layer boundaries strictly:
  presentation → domain → data
- Each layer must have a single responsibility.
- Never bypass layers or mix responsibilities.
- Do not put business logic inside the UI (presentation layer).
- UI must only handle rendering, user interaction, and state observation.
- All business logic must reside in domain layer and be triggered via Cubit/UseCases.
- Data layer must only handle API calls, persistence, and data mapping.
- Do not introduce unnecessary abstractions or overengineering.
  lib/
  ├── main.dart # Entry point, bootstrapping
  ├── better_you_app.dart # MaterialApp root widget
  ├── config/ # App-wide config
  │ ├── app_config.dart
  ├── core/ # Shared utilities used across features
  | |\_\_ theme/
  │ ├── app_colors.dart
  │ ├── app_text_styles.dart
  │ ├── app_theme.dart
  │ ├── constants/
  │ ├── helpers/
  │ ├── services/
  │ └── widgets/
  └── features/
  └── <feature_name>/
  ├── data/ # Datasources, models, repository impls
  │ ├── datasources/
  │ ├── models/
  │ └── repositories/
  ├── domain/ # Entities, repository contracts, use cases
  │ ├── entities/
  │ ├── repositories/
  │ └── usecases/
  └── presentation/ # UI: screens, cubits, widgets
  ├── cubit/
  ├── screens/
  ├── views/
  └── widgets/

## Apply SOLID, DRY, and sound engineering principles

- Apply SOLID, DRY, and other sound engineering principles when beneficial.
- Do not force patterns unnecessarily.

## Root-cause first

- Always identify and fix the root cause, not just symptoms.
- Do not apply superficial fixes.

## Minimal safe changes

- Make the smallest possible change that solves the problem.
- Do not refactor unrelated code unless explicitly requested.

## No breaking changes

- Do not break existing functionality, APIs, flows, or UX unless explicitly instructed.

## Follow repository conventions

- Follow existing architecture, folder structure, naming conventions, and patterns.
- Do not introduce a new style inconsistent with the project.

## Core folder for shared components

- Any reusable logic, utilities, services, constants, extensions, helpers, or shared components used in more than one place must be placed in the core/ folder.
- Avoid duplication across features.

## Performance awareness (Flutter)

- Follow Flutter performance best practices at all times.
- Avoid unnecessary widget rebuilds.
- Prefer const constructors wherever possible.
- Avoid heavy work inside build methods.
- Be careful when using setState:
  - Use setState only for local UI state when necessary.
  - Never use setState for business logic or feature state.
  - Prefer Cubit for managing feature and application state.
  - Avoid triggering unnecessary rebuilds of large widget trees.
- Prefer efficient widget composition and separation to minimize rebuild scope.
- Avoid unnecessary object allocations inside build methods.
- Avoid creating controllers (`TextEditingController`, `AnimationController`), `FocusNode`, or other expensive objects inside `build()`.
- Dispose controllers and focus nodes properly when owned by widgets (use `dispose()` in `StatefulWidget`).

## State management discipline (Cubit / Clean Architecture)

- Use Cubit/Bloc for feature state and business logic coordination.
- UI must never contain business logic.
- UI must only observe state and trigger Cubit actions.
- Do not bypass architecture layers.

## Edge cases and error handling

- Properly handle null, empty, loading, and error states.
- Do not allow silent failures.
- Always ensure safe and predictable behavior.
- Use a consistent error handling strategy across layers:
  - Data layer: catch exceptions and map them to typed Failure/Error classes.
  - Domain layer: return Result types (e.g., Either<Failure, Success>) from use cases/repositories.
  - Presentation layer: map failures to user-friendly messages and appropriate UI states.
- Errors must propagate cleanly: data → domain → presentation, never skip layers.

## Dependencies rule

- Do not add new packages unless necessary and justified.
- Any package added must be:
  - Latest stable version
  - Well-maintained
  - Production-grade and trusted

## Security awareness

- Always consider security implications.
- Proactively warn about potential security risks.
- Never hardcode secrets, tokens, or credentials.
- Do not log sensitive information.
- Safely validate and handle external and API data.

## Follow modern best practices

- Always follow current (2026) best practices and modern Flutter/Dart standards.
- Prefer native Dart 3+ features over code generation libraries:
  - Use `sealed class` for state unions and exhaustive pattern matching.
  - Use `switch` expressions and pattern matching for control flow.
  - Use records for lightweight data grouping when appropriate.
  - Avoid Freezed or other code generation unless the project explicitly adopts it.
  - Keep the project free from unnecessary build_runner dependencies.

## Team mindset (engineering partner mode)

- Act as a senior engineer partner, not just a task executor.
- Suggest improvements when valuable.
- Think critically about solutions.
- Explain tradeoffs briefly when relevant.

## No assumptions without verification

- Always read and understand relevant code before modifying it.
- Do not assume behavior without verification.
- Ask or clearly state assumptions if something is unclear.

## Avoid duplication

- Reuse existing logic when available.
- Do not duplicate code unnecessarily.

## Dart naming conventions and best practices

- Follow official Dart style guide and conventions:
  - Files: `snake_case.dart`
  - Classes, enums, typedefs: `PascalCase`
  - Variables, functions, parameters: `camelCase`
  - Constants: `camelCase` (not SCREAMING_CAPS)
  - Private members: prefix with `_`
- Feature folder structure: `feature_name/data/`, `feature_name/domain/`, `feature_name/presentation/`
- Follow Effective Dart guidelines for API design, usage, and documentation.

## Import ordering

- Organize imports in this order, separated by blank lines:
  1. Dart SDK imports (`dart:`)
  2. Flutter SDK imports (`package:flutter/`)
  3. Third-party package imports (`package:`)
- Use relative imports within for project files, strictly relative imports everywhere within lib/.
- Never use unused imports.

## Testing discipline

- Write unit tests for domain and data layer logic.
- Write widget tests for critical UI flows.
- Bug fixes must include a test that reproduces the issue.
- Follow existing test structure and naming conventions.
- Tests must be deterministic — no flaky or timing-dependent tests.
- Keep tests focused: one behavior per test case.

## Separation of concerns enforcement

- Presentation layer must not directly access repositories or data sources.
- All business operations must go through domain use cases.
- Cubits must depend only on use cases, never directly on repositories or data sources.
- Domain layer must remain independent of Flutter and UI frameworks.

## Completion self-review checklist (mandatory)

Before finishing any task, verify:

- The root cause is correctly addressed.
- The solution is safe and minimal.
- No existing functionality is broken.
- Architecture rules are respected.
- No business logic exists in UI.
- No performance regressions introduced.
- No security risks introduced.

Then provide a brief summary of:

- What was changed
- Why it was changed
- Why the solution is safe and correct
