 E-Commerce Cart Application - Flutter
 Project Architect
 ![Снимок экрана 2025-04-04 113627](https://github.com/user-attachments/assets/67650747-a485-459c-aa1f-17fcbafc7af7)
 ![Снимок экрана 2025-04-04 113635](https://github.com/user-attachments/assets/6473a0d2-652f-47dd-9b30-6025e5786b72)
 ![Снимок экрана 2025-04-04 113653](https://github.com/user-attachments/assets/37f73c9a-2162-4ab9-a0b5-f32403f4b8c4)
 ![Снимок экрана 2025-04-04 113702](https://github.com/user-attachments/assets/172082de-83c3-4060-9cf2-aa00db54a7f5)
 ![Снимок экрана 2025-04-04 113708](https://github.com/user-attachments/assets/a79cb2f4-52f9-4944-a082-196c8c49577a)
 ![Снимок экрана 2025-04-04 113804](https://github.com/user-attachments/assets/4777fef4-f8b4-41dd-be85-fbac9ff822d9)






 A Flutter e-commerce application featuring a shopping cart system with various functionalities including cart management, user authentication, and product catalog.
 A sleek and functional Flutter shopping app with cart management, user authentication, and a dynamic product catalog! Built with ❤️ using Hive, SharedPreferences, and JSON for seamless data handling.

✨ Key Features
🔐 User Authentication
Login Page ✅

Validates users against login.json

Shows error if credentials don’t match ❌

Register Page 📝

Checks if a user already exists (via login.json)

Stores new users in Hive 🗄️

Auto-login after registration 🎉

🛍️ Product & Cart Management
Catalogue Page 📋

Fetches products from store.json (images, titles, descriptions)

Displays in a beautiful Grid Layout 🖼️

Cart Page 🛒

Add/Remove items ➕➖

Adjust quantities 🔢

Clear entire cart 🗑️

Place orders (resets cart & updates total) 💳

🔄 State & Data Management
GLOBAL.dart 🌍

Manages shared app state

Transfers data between pages via IndexedStack

Profile Page 👤

Displays user data from login/register
Getting Started
 Clone the repository

 Run flutter pub get to install dependencies

 Run the app with flutter run





![Снимок экрана 2025-04-04 115504](https://github.com/user-attachments/assets/78db627e-d0fd-4979-a618-1e76f949c13b)


 dependencies:
  shared_preferences: ^2.0.15  # 🔐 Save user settings
  hive: ^2.2.3                # 🗃️ NoSQL local storage
  hive_flutter: ^1.1.0        # 📱 Flutter Hive integration
  flutter:
    sdk: flutter
![image](https://github.com/user-attachments/assets/c2898d1a-0b09-4d0c-bafe-2c3af1d3ed3a)


 🎯 Future Improvements
Wishlist Feature ❤️

Payment Gateway Integration 💳

Dark Mode Support 🌙
