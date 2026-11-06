# SuperHeroFit

SuperHeroFit is an iOS application designed to gamify physical activity by transforming daily fitness metrics into virtual superhero progression. Built natively in Swift using SwiftUI, SwiftData, and HealthKit, the application tracks user movement, manages recurring fitness challenges, and rewards active lifestyles with in-app currency used to unlock and customize a multi-layered superhero avatar.

Originally conceived and developed as a prototype during the Negroni Challenge at the Apple Developer Academy by team FVLAS, SuperHeroFit demonstrates modern declarative iOS development, local-first persistence, and seamless system health framework integration.

---

## Table of Contents

- [Overview](#superherofit)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
  - [Architectural Pattern](#architectural-pattern)
  - [Directory Structure](#directory-structure)
  - [Domain Models](#domain-models)
  - [HealthKit Integration](#healthkit-integration)
  - [Avatar Rendering Engine](#avatar-rendering-engine)
- [Frameworks and Technologies](#frameworks-and-technologies)
- [Application Workflow](#application-workflow)
  - [1. User Onboarding and Data Preloading](#1-user-onboarding-and-data-preloading)
  - [2. Activity Monitoring and Challenge Progression](#2-activity-monitoring-and-challenge-progression)
  - [3. Economic Loop and Avatar Customization](#3-economic-loop-and-avatar-customization)
- [Installation and Configuration](#installation-and-configuration)
  - [Prerequisites](#prerequisites)
  - [Building and Running](#building-and-running)
- [Project Context and Origin](#project-context-and-origin)
- [License](#license)

---

## Key Features

- **Activity Tracking**: Real-time retrieval of daily walking and running metrics, including step counts and distance traveled, powered by HealthKit.
- **Goal-Oriented Challenges**: Configurable fitness objectives based on step counts or kilometers, supporting target deadlines, streak calculation, and dynamic reward distribution.
- **In-App Reward Economy**: A closed-loop virtual economy where physical activity directly converts to wallet currency based on performance thresholds.
- **Layered Avatar Customization**: A modular 2D avatar rendering system allowing users to equip unlocked cosmetic assets across multiple anatomical layers (masks, capes, gloves, wings, and auras).
- **Categorized In-Game Shop**: An item catalog organized by equipment category, featuring purchase verification, price validation, and instant inventory reflection.
- **SwiftData Persistence**: A fully local-first architecture ensuring immediate state restoration, offline access, and transactional integrity for user profiles, items, and active challenges.

---

## System Architecture

### Architectural Pattern

The application implements a declarative, component-driven SwiftUI architecture coupled with Apple's SwiftData framework for reactive model persistence:

- **Views**: Declarative SwiftUI structures responsible for user interaction and rendering. Views observe query states directly using SwiftData property wrappers (`@Query`), minimizing boilerplate synchronization code.
- **Components**: Reusable, single-responsibility UI elements such as `AvatarView`, `HeroShopItem`, and `ProfileItem` that decouple presentation from state mutations.
- **Managers**: Dedicated service objects (such as `HealthKitManager`) that abstract system framework complexities behind completion handlers and asynchronous interfaces.
- **Persistence Layer**: SwiftData schema containers configured at the application root (`NegroniChallengeFVLASApp`), injecting a shared `ModelContext` throughout the view hierarchy.

### Directory Structure

```
SuperHeroFit/
|-- NegroniChallengeFVLAS.xcodeproj
|-- NegroniChallengeFVLAS/
|   |-- NegroniChallengeFVLASApp.swift      # Application entry point and model container setup
|   |-- NegroniChallengeFVLAS.entitlements  # HealthKit capabilities and background delivery
|   |-- Models/
|   |   |-- User.swift                     # User profile, wallet, and equipped loadout
|   |   |-- Challenge.swift                # Challenge entities, streak tracking, and reward algorithms
|   |   |-- AvatarItem.swift               # Item catalog, categorization, and color taxonomy
|   |   +-- HealthKitManager.swift         # HealthKit permissions and statistical query wrapper
|   |-- Views/
|   |   |-- ContentView.swift              # Root navigation and authentication router
|   |   |-- WelcomeView.swift              # First-launch onboarding and database seeding
|   |   |-- HomeView.swift                 # Main dashboard, daily quotes, and challenge status
|   |   |-- ActiveChallengeView.swift      # Ongoing challenge details and metrics
|   |   |-- ChallengeListView.swift        # Available and historical challenge management
|   |   |-- ShopView.swift                 # Item marketplace with category filtering
|   |   |-- WardrobeSectionView.swift      # Inventory viewer and cosmetic selection
|   |   +-- ProfileView.swift              # User profile, statistics, and settings
|   |-- Components/
|   |   |-- AvatarView.swift               # Multi-layer compositing engine for avatar graphics
|   |   |-- HeroShopItem.swift             # Marketplace grid card component
|   |   +-- ProfileItem.swift              # Configurable list row component
|   +-- Assets.xcassets/                   # Vector and raster assets for modular hero components
|-- LICENSE
+-- README.md
```

### Domain Models

The data layer is managed via SwiftData models annotated with `@Model`:

- **User**: Encapsulates the user profile, wallet balance, unlocked wardrobe items, and current equipment slots (mask, cape, gloves, and aura/wings).
- **Item**: Defines cosmetic equipment metadata including unique identifier, asset name, component type, purchase cost, color palette, category (`mask`, `cape`, `gloves`, `others`), and unlock status.
- **Challenge**: Represents a discrete fitness goal, tracking the target metric (`steps` or `kilometers`), target value, duration in days, start/end timestamps, completion state, active streaks, and computed reward value.

### HealthKit Integration

The `HealthKitManager` class encapsulates communication with the Apple Health subsystem:

- **Authorization**: Manages user consent for reading and sharing `HKQuantityTypeIdentifier.stepCount` and `HKQuantityTypeIdentifier.distanceWalkingRunning`.
- **Statistical Aggregation**: Uses `HKStatisticsQuery` with cumulative sum aggregation options to compute accurate daily step counts restricted by calendar day boundaries (`startOfDay` to current timestamp).
- **Entitlements**: Configured with background delivery capabilities to support asynchronous metric synchronization.

### Avatar Rendering Engine

The avatar customization system (`AvatarView`) uses a Z-ordered depth compositing strategy to generate consistent 2D representations from discrete sprite layers:

1. **Backdrop Layer**: Auras, energy fields, and wings (`Sparkle`, `AngelWings`, `DragonWings`, colored auras).
2. **Back Layer**: Lower portion of capes positioned behind the torso.
3. **Base Anatomy**: Standard base torso (`HeroBody`).
4. **Front Layer**: Upper drape of capes overlapping the shoulder boundary.
5. **Head Anatomy**: Base head illustration (`HeroHead`).
6. **Facial Layer**: Equipped masks aligned to facial coordinates.
7. **Foreground Layer**: Handwear and combat gloves (`RedGloves`, `BlueGloves`, etc.) aligned to the forearm baseline.

---

## Frameworks and Technologies

- **Swift**: Core programming language utilizing strict type safety and modern language constructs.
- **SwiftUI**: Declarative user interface framework powering dynamic layouts, animations, and transitions.
- **SwiftData**: Apple's modern persistence framework providing compile-time schema validation and native Swift modeling.
- **HealthKit**: Native iOS framework for querying and observing health and activity records.
- **Foundation & Combine**: System frameworks for date math, scheduling, and reactive property bindings.

---

## Application Workflow

### 1. User Onboarding and Data Preloading
Upon initial launch, `ContentView` evaluates the `users` query:
- If no user record exists, the application presents `WelcomeView`.
- Triggering the primary action inserts an initialized `User` record into the `ModelContext`.
- A bundled catalog of initial items (`ItemData`) is seeded into SwiftData, marking standard baseline assets as unlocked.

### 2. Activity Monitoring and Challenge Progression
- The dashboard queries `HealthKitManager` to obtain the user's daily metrics.
- Active challenges compare current step or distance samples against the established target value.
- Upon reaching target metrics, the challenge is evaluated, streaks are incremented, and reward currency is credited directly to the user's wallet.

### 3. Economic Loop and Avatar Customization
- Users browse the `ShopView` to inspect locked items categorized by equipment slot.
- Selecting an item initiates a transaction check verifying that `wallet >= item.price`.
- Successful transactions deduct currency, update `item.unlocked = true`, and append the item to the user's wardrobe.
- Users can equip unlocked cosmetics via the wardrobe interface, immediately updating `User` references and triggering live re-renders in `AvatarView`.

---

## Installation and Configuration

### Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Target Device: iPhone with iOS 17.0 or later (or iOS Simulator)
- An active Apple Developer account for testing HealthKit capabilities on physical hardware

### Building and Running

1. Clone the repository:
   ```bash
   git clone https://github.com/vincenzopiconee/SuperHeroFit.git
   cd SuperHeroFit
   ```

2. Open the Xcode project:
   ```bash
   open NegroniChallengeFVLAS.xcodeproj
   ```

3. Configure Signing:
   - Select the `NegroniChallengeFVLAS` target in Xcode.
   - Under the **Signing & Capabilities** tab, select your Development Team.
   - Ensure the **HealthKit** capability is active and the associated entitlement (`NegroniChallengeFVLAS.entitlements`) is linked.

4. Select a run destination:
   - To test HealthKit data collection, run on a physical iPhone with Apple Health data, or manually input step samples via Simulator (**Features > HealthKit**).

5. Build and run the project:
   - Press `Cmd + R` or click the **Play** button in Xcode.

---

## Project Context and Origin

This repository represents a prototype project originally created during the **Negroni Challenge** at the **Apple Developer Academy (Naples, Italy)** by team **FVLAS**. 

Because this project was initiated during an intensive sprint, the internal Xcode target and directory retain the original project codename (`NegroniChallengeFVLAS`), while the application is presented and branded as **SuperHeroFit**.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for full details.
