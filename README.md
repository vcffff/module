Shopping Cart in Flutter
This project is a Flutter application that implements the functionality of a shopping cart. Users can add items to the cart, change their quantity, remove them, and place an order. All cart data is stored using the SharedPreferences package, so the cart is not cleared after the app is restarted.

Key Features:
View items in the cart

Change the quantity of items

Remove items from the cart

Clear the entire cart

Place an order with total price calculation

Local data storage using SharedPreferences

Project Structure:
main.dart: The main entry point of the app, where initialization and app launch occur.

cartmain.dart: The cart page, where the items and actions related to the cart are displayed.

catalogue.dart: The product catalog page (not fully detailed but implied).

profile.dart: The user profile page (not fully detailed but implied).

Dependencies:
shared_preferences: For local data storage (shopping cart data).

hive: For working with local databases (can be used for storing other data if needed).

hive_flutter: Flutter integration for Hive.

dart:convert: For working with JSON and encoding/decoding data.

Installation
Clone the repository:

bash
Копировать
Редактировать
git clone https://github.com/your-repository.git
Navigate to the project directory:

bash
Копировать
Редактировать
cd project-name
Install dependencies:

bash
Копировать
Редактировать
flutter pub get
Run the app:

bash
Копировать
Редактировать
flutter run
Features:
Cart Page (CartPage)
On the main cart page, you can:

Change the quantity of items.

Remove items from the cart.

Clear the entire cart.

Place an order, which clears the cart and updates the total price.

