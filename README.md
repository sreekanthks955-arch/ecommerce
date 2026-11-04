# ShopEase

ShopEase is a beginner-friendly Flutter storefront demo. It uses sample products, local storage, and demo-only sign-in and checkout. It does not connect to an API or backend, and it never takes a real payment.

## Run the app

1. Install Flutter and enable platform setup for your device or emulator.
2. From the project folder, run `flutter pub get`.
3. Start the app with `flutter run`.

The first launch opens a short splash screen and onboarding. You can skip onboarding to browse as a guest. For the demo sign-in form, enter any valid email address and a password with at least six characters.

## Project map

- `lib/main.dart` initializes Hive, registers the GetX controllers, and starts the app.
- `lib/models/` contains the simple product and order data classes.
- `lib/controllers/app_controllers.dart` contains the sample catalog, shopping state, validation, and local profile/order behavior.
- `lib/services/app_theme.dart` contains the shared colors and Material theme.
- `lib/widgets/shop_widgets.dart` contains reusable buttons, product cards, image placeholders, and empty states.
- `lib/pages/splash/` and `lib/pages/onboarding/` contain the app entry screens.
- `lib/pages/auth/` contains local-validation sign-in and registration forms.
- `lib/pages/home/` contains the home page and four-tab navigation.
- `lib/pages/categories/` and `lib/pages/products/` contain category browsing, listings, details, and search.
- `lib/pages/cart/` and `lib/pages/wishlist/` contain the locally saved shopping bag and saved products.
- `lib/pages/checkout/` contains checkout, address editing, demo payment choices, and order confirmation.
- `lib/pages/profile/` contains profile editing, settings, and help.
- `lib/pages/orders/` contains local order history and illustrative tracking.

Hive stores the sample catalog, cart quantities, wishlist, and demo orders. SharedPreferences stores profile details and simple preferences on the device.
