![Group 13](https://github.com/user-attachments/assets/5da27e58-7c0d-49df-be19-759d435fa286) E-Commerce Cart Application - Flutter
 Project Architecture

 A Flutter e-commerce application featuring a shopping cart system with various functionalities including cart management, user authentication, and product catalog.

Features
Core Functionalities
Cart Management:

  Change quantity of items in the cart
  
  Remove individual items from the cart
  
  Clear the entire cart with one action
  
  Place orders (clears cart and updates total price)

Technical Implementations
  State Management: Uses GLOBAL.dart for shared application state
  
  Local Storage:
  
  shared_preferences for persistent user data and preferences
  
  hive for efficient local data storage

Data Handling:

  dart:convert for JSON serialization/deserialization
  
  Product data loaded from cat.json
  
  Login data stored in login.json

UI Components
  CartPage.dart: Main cart interface with all cart operations
  
  Catalogue.dart: Product listing page
  
  ProductPage.dart: Individual product details
  
  Login.dart & Register.dart: User authentication screens
  
  Profile.dart: User profile management

Getting Started
 Clone the repository

 Run flutter pub get to install dependencies

 Run the app with flutter run

Dependencies
  shared_preferences: ^2.0.15
  
  hive: ^2.2.3
  
  hive_flutter: ^1.1.0
  
  flutter:
  sdk: flutter

JSON Data Structure
Products are loaded from store.json which should follow this structure:
     [
  {
    "name": "Ноутбук ASUS VivoBook 15",
    "desc": "Мощный и стильный ноутбук с процессором Intel Core i5, 8 ГБ ОЗУ и SSD на 512 ГБ.",
    "price": 350000,
    "images": [
      "images/laptop_asus1.jpeg"
    ]
  },
  ]

