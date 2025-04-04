 E-Commerce Cart Application - Flutter
 Project Architect![Снимок экрана 2025-04-04 113804](https://github.com/user-attachments/assets/4777fef4-f8b4-41dd-be85-fbac9ff822d9)
![Снимок экрана 2025-04-04 113708](https://github.com/user-attachments/assets/a79cb2f4-52f9-4944-a082-196c8c49577a)
![Снимок экрана 2025-04-04 113702](https://github.com/user-attachments/assets/172082de-83c3-4060-9cf2-aa00db54a7f5)
![Снимок экрана 2025-04-04 113653](https://github.com/user-attachments/assets/37f73c9a-2162-4ab9-a0b5-f32403f4b8c4)
![Снимок экрана 2025-04-04 113635](https://github.com/user-attachments/assets/6473a0d2-652f-47dd-9b30-6025e5786b72)
![Снимок экрана 2025-04-04 113627](https://github.com/user-attachments/assets/67650747-a485-459c-aa1f-17fcbafc7af7)
ure

 A Flutter e-commerce application featuring a shopping cart system with various functionalities including cart management, user authentication, and product catalog.

Features
Core Functionalities:
   Login page(has validation):
   It is checked by login.json.If there is no user with that name and password it will show error message.
   Registerpage(has validation):
   It is also checked by login.json then compare it does that user exist if it return false it will add into Hivebox then in profile page it will it from that box
   Cataloguepage:
   This page got the datas from store.json(photos,titles,descriptions) then show it in Grid layout
   Cartpagepage:
   This page will save datas from CataloguePage if the user had clicked 'Добавить в корзинку' 
   key features:
     Change quantity of items in the cart
     Remove individual items from the cart
     Clear the entire cart with one action
     Place orders (clears cart and updates total price)
   global.dart:
   It is class  for saving data like quantity,name and will transfet it between pages in IndexedStack.
   Profilepage:
   This page will show data  from login or registerpage

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

