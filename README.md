# Project Architecture

This document defines the architecture baseline for SwiftUI MV projects.
It standardizes module boundaries, dependency direction, composition, navigation ownership, and shared state rules.
Use these conventions as the default implementation policy so features remain decoupled, testable, and scalable over time.

## Standard Layout

```text
MyApp/
  App/
    MyApp.swift
    AppContainer.swift
    AppRoute.swift
    RootView.swift
  Domain/
    Models/
    Repositories/
  Application/
    UseCases/
    Stores/
  Data/
    Local/
    Remote/
    Purchases/
    Repositories/
  Presentation/
    Screens/
      Home/
      Settings/
    DesignSystem/
      Components/
      Tokens/
  Infrastructure/
    Sync/
    Telemetry/
  Support/
    Notifications/
    Haptics/
  Resources/
    Assets.xcassets
    Localizable.xcstrings
    Config/
  MyAppWidget/
  Tests/
    DomainTests/
    ApplicationTests/
    DataTests/
    PresentationTests/
```

## Layer Responsibilities

- `App`: own composition root, app lifecycle, and app-level navigation.
- `Domain`: own business entities and repository contracts.
- `Application`: own use cases and app-level or cross-screen state stores.
- `Data`: own repository implementations and external data access.
- `Presentation`: own feature screens and feature models (MV).
- `Infrastructure`: own technical adapters such as sync and telemetry.
- `Support`: own utility groups for platform effects (notifications, haptics).
- `Resources`: own assets and runtime config files.

## Dependency Direction

- Allow `Presentation -> Application -> Domain`.
- Allow `Data -> Domain`.
- Allow `App` to wire `Application`, `Data`, and `Presentation`.
- Avoid direct `Presentation -> Data`.
- Avoid `Domain` importing upper layers.

## Swift 6 Concurrency

- Isolate feature models with `@MainActor`.
- Keep UI state mutation on main actor only.
- Mark cross-boundary contracts and payloads as `Sendable`.
- Treat `CancellationError` as control flow, not user-facing error state.
- Avoid `Task.detached` in feature-level logic.

## Navigation Ownership

- Keep app-level route definition in `AppRoute`.
- Keep root `NavigationStack` in `RootView`.
- Keep feature models unaware of app-wide route types; expose intents and callbacks.
- Default to native SwiftUI navigation APIs. Add a thin navigator only when flow complexity requires it.

## Shared State Guidance

- Keep global state minimal and explicit in `Application/Stores`.
- Keep feature-local state inside each `Presentation/Screens/<Feature>/<Feature>Model`.
- Promote state to app-level only when multiple screens require shared ownership.
