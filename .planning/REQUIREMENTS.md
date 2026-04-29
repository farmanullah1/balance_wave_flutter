# Requirements: BalanceWave Flutter

## Functional Requirements
1. **Balance Calculation (Forward)**:
   - Input: Recharge Amount (Rs.).
   - Formula: `Net = Amount / (1 + 0.15)`.
   - Output: Net Balance, Tax Amount (Amount - Net).
2. **Recharge Calculation (Reverse)**:
   - Input: Desired Net Balance (Rs.).
   - Formula: `Required = Amount * (1 + 0.15)`.
   - Output: Required Recharge, Tax Amount (Required - Amount).
3. **Carrier Detection**:
   - Auto-detect carrier based on 11-digit mobile number prefix (e.g., 0300 -> Jazz).
   - Support prefixes for Jazz, Zong, Ufone, Telenor, Onic, and SCOm.
   - Manual carrier selection override.
4. **Copy to Clipboard**:
   - Copy calculation results to clipboard with a single tap.
5. **Vibration Feedback**:
   - Provide haptic feedback on calculation and copy actions.

## UI/UX Requirements
1. **Modern Aesthetic**:
   - Glassmorphism effects (blurred backgrounds, translucent cards).
   - Premium dark/light mode support (system-based or toggle).
2. **3D Animations**:
   - Smooth transitions between screens.
   - Interactive 3D elements (e.g., rotating cards or animated backgrounds).
3. **Carrier Branding**:
   - Display carrier logos and colors dynamically.
4. **Responsive Layout**:
   - Optimized for mobile screens (Android/iOS).

## Technical Requirements
1. **Flutter Packages**:
   - `google_fonts`: For modern typography.
   - `provider`: For state management.
   - `animate_do`: For animations.
   - `flutter_lucide`: For Lucide icons.
   - `glassmorphism`: For glass effects.
   - `vibration`: For haptic feedback.
   - `flutter_svg`: For carrier logos.
