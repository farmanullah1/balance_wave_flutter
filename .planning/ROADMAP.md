# Roadmap: BalanceWave Flutter

## Milestone 1: Core Foundation & Logic
- **Phase 1: Project Setup & Dependencies**
  - Configure `pubspec.yaml` with required packages.
  - Set up directory structure (models, providers, screens, widgets, utils).
  - Define theme data (Glassmorphism theme).
- **Phase 2: Data Models & Business Logic**
  - Implement `Carrier` model and constants.
  - Implement calculation logic (forward/reverse formulas).
  - Implement carrier detection utility.
- **Phase 3: State Management**
  - Set up `CalculatorProvider` to handle inputs and results.

## Milestone 2: UI Implementation
- **Phase 4: Glassmorphism Components**
  - Create reusable `GlassCard` and `GlassInput` widgets.
  - Implement custom 3D-style buttons.
- **Phase 5: Main Calculator Screen**
  - Build the input form (Mobile number, Carrier select, Amount).
  - Integrate auto-detection logic into the form.
- **Phase 6: Results Display**
  - Build the animated result card with breakdown.
  - Implement copy-to-clipboard and vibration feedback.

## Milestone 3: Polish & Refinement
- **Phase 7: Advanced Animations**
  - Add 3D transitions and entry animations using `animate_do`.
  - Implement background wave animation (matching the name "BalanceWave").
- **Phase 8: Final Audit & Testing**
  - Verify formulas against React version.
  - Test on multiple screen sizes.
  - Ensure dark/light mode consistency.
