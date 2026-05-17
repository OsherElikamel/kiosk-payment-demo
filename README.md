# PayTag Kiosk — Self-Checkout Simulator

A desktop self-checkout kiosk simulator built with Flutter. Simulates the full retail flow: RFID tag scanning, item display, payment method selection, and payment processing with configurable success/failure outcomes. Supports multiple stores, bilingual UI (English/Hebrew), and detailed payment logging.

Built as a technical assignment for PayTag.

## Tech Stack

- **Flutter 3.6+** — desktop app (Windows, macOS, Linux)
- **Provider** — state management
- **Excel** — RFID tag data simulation (reads `.xlsx` files at runtime)
- **SharedPreferences** — persistent settings
- **PathProvider** — log file storage

## How to Run

```bash
# Clone and install
git clone https://github.com/OsherElikamel/kiosk-payment-demo.git
cd kiosk-payment-demo
flutter pub get

# Run (pick your platform)
flutter run -d linux
flutter run -d macos
flutter run -d windows

# Run with a specific store
flutter run -d linux --dart-define=store=STORE_002
```

## App Flow

```
Welcome → Scanning → Proceed to Payment → Payment Method → Processing → Result → Demo Ended
    ↑                                                                                  |
    └──────────────────────────────── Restart ──────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart               # Entry point, multi-store init
├── app.dart                # PaytagApp root widget with Provider
├── theme.dart              # Centralized ThemeData
├── common/
│   ├── colors.dart         # Brand colors and gradients
│   ├── app_strings.dart    # Bilingual strings (EN/HE)
│   ├── app_assets.dart     # Asset path constants
│   └── app_dimensions.dart # Spacing and layout constants
├── core/
│   └── store_config.dart   # Store configuration model
├── models/
│   └── tag_item.dart       # Scanned item data model
├── providers/
│   └── kiosk_provider.dart # App state (scanned items, payment, scanning)
├── screens/
│   ├── welcome_screen.dart
│   ├── scanning_screen.dart
│   ├── proceed_screen.dart
│   ├── payment_method_screen.dart
│   ├── payment_processing_screen.dart
│   ├── payment_result_screen.dart
│   ├── demo_ended_screen.dart
│   └── store_picker_app.dart
├── services/
│   ├── local_backend.dart          # RFID simulation (Excel parsing)
│   ├── logger.dart                 # File-based payment logging
│   └── payments/
│       └── payment_method.dart     # Payment method model + processing
├── widgets/
│   ├── big_button.dart             # Gradient CTA button
│   ├── scanned_items_list.dart     # Horizontal item carousel
│   └── secret_dialog.dart          # Developer mode dialog
assets/
├── stores.json             # Multi-store configuration
├── tag_data_local.xlsx     # Product database (tag ID → price + image)
├── tag_inputs/             # Simulated RFID scan input files
├── images/                 # Product images + store logos
└── flags/                  # Language toggle flags
```

## Multi-Store Support

Stores are defined in `assets/stores.json`. Each store has its own currency, logo, and set of payment methods with configurable success probability and processing delay.

Select a store at launch via `--dart-define=store=STORE_002` or through the secret developer mode.

## Developer Mode

Tap the store logo **7 times** on the welcome screen to open the developer panel. From there you can:
- Switch between stores
- Toggle language (English/Hebrew)
- Open the logs folder

## Payment Logging

All payment attempts are logged to daily files in the app's support directory. Logs include payment ID, store, method, amount, currency, and success/failure status.
