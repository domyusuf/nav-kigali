# Nav Kigali - Kigali City Services Directory

This project is a Flutter mobile application that helps people in Kigali find and navigate to essential services like hospitals, police stations, and restaurants.

## Project Overview
The app is connected to Firebase for authentication and data storage. Users can sign up, log in, and manage their own listings of places in the city. It also uses Google Maps to show exactly where locations are.

## Key Features
*   **User Authentication:** Sign up and Login with Firebase. You must verify your email before you can use the app.
*   **Listings (CRUD):** You can view all places in the "Directory" and manage your own places in "My Listings" (Add, Edit, and Delete).
*   **Search & Filter:** You can search for places by name and filter them by categories like 'Hospital' or 'Park'.
*   **Maps & Navigation:** Every place has an embedded Google Map. There is a button that opens Google Maps for turn-by-turn directions.
*   **Settings:** A screen to see your profile email and toggle notification preferences.

## How the App is Built (Architecture)
I used the **Provider** package for state management to keep the UI separate from the backend logic.

*   **Services:** `auth_service.dart` and `firestore_service.dart` handle all the direct calls to Firebase.
*   **Providers:** `auth_provider.dart` and `listing_provider.dart` manage the app state and notify the UI to rebuild when data changes.
*   **Models:** `listing_model.dart` and `user_model.dart` define how the data looks.

## Database Structure (Firestore)
I used two main collections in Cloud Firestore:

1.  **users**: Stores user information.
    *   `email`: User's email address.
    *   `createdAt`: When the account was made.
2.  **listings**: Stores all the places shown in the app.
    *   `name`, `category`, `address`, `contactNumber`, `description`.
    *   `latitude` and `longitude`: For the map coordinates.
    *   `createdBy`: The UID of the user who added it.
    *   `timestamp`: When it was added.

## Setup Instructions
1.  Run `flutter pub get` to install dependencies.
2.  Run `flutterfire configure` to connect to your own Firebase project.
3.  Add your Google Maps API Key in:
    *   `android/app/src/main/AndroidManifest.xml`
    *   `ios/Runner/AppDelegate.swift`
4.  Enable Email/Password Auth and Firestore in your Firebase Console.
5.  Run the app using `flutter run`.
