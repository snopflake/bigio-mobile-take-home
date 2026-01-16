# BIGIO Morty Verse

## Introduction
**BIGIO Morty Verse** is a Flutter (Android) application built for **BIGIO Mobile Developer – Take Home Challenge**.  
The app consumes **Rick and Morty API** to display a list of characters, show character details, and provide search functionality.  
It implements **Clean Architecture (data/domain/presentation)** with **BLoC** state management, **Dio** networking, **GoRouter** navigation, **GetIt** dependency injection, and **SQLite (sqflite)** for favorites persistence.

> Package name: `com.takehomechallenge.salsabila`

---

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Libraries](#libraries)
- [Project Structure](#project-structure)
- [APK Link](#apk-link)
- [How to Run](#how-to-run)
- [Testing](#testing)
- [Disclaimer](#disclaimer)

---

## Features
### Required
- **Home Page**
  - Display character list (paginated)
  - Tap item → **Detail Page**
  - States handled: **Loading / Loaded / Error / Empty**
- **Detail Page**
  - Display: **name, species, gender, origin, location, image**
  - Toggle **favorite**
  - States handled: **Loading / Loaded / Error**
- **Search Page**
  - Search characters by user input
  - Tap item → **Detail Page**
  - States handled: **Loading / Loaded / Error / Empty**

### Additional
- **Favorites (SQLite using sqflite)**
  - Persist favorites locally
  - Favorites sync handled via `FavoritesSyncCubit`
- **Favorites Page**
  - List saved favorites
  - Remove favorite from list
- **Testing**
  - Unit tests for domain usecases
  - Cubit test for favorites sync
  - Widget test for UI key exposure

---

## Libraries
- **Flutter**: `3.35.4`
- **State Management**: `flutter_bloc`, `equatable`
- **Networking**: `dio`, `pretty_dio_logger`
- **Dependency Injection**: `get_it`
- **Routing**: `go_router`
- **Local Database**: `sqflite`, `path`
- **Image Cache**: `cached_network_image`
- **UI Utils**: `flutter_screenutil`, `flutter_spinkit`
- **Functional**: `dartz`
- **Testing**: `flutter_test`, `bloc_test`, `mocktail`
- **App Icon**: `flutter_launcher_icons`

---

## Project Structure

Clean Architecture (data / domain / presentation) is applied under `lib/`.

```text
lib/
 ├─ core/
 │   ├─ di/                 # GetIt setupInjector
 │   ├─ error/              # Failure models
 │   ├─ local_db/           # SQLite database helper
 │   ├─ network/            # Dio client config
 │   ├─ routes/             # GoRouter routes
 │   ├─ testing/            # AppKeys for widget testing
 │   ├─ theme/              # App theme setup
 │   └─ widgets/            # Shared widgets
 │
 ├─ features/
 │   └─ characters/
 │       ├─ data/
 │       │   ├─ datasources/    # Remote & local data sources
 │       │   ├─ models/         # DTO / model mapping
 │       │   └─ repositories/   # Repository implementations
 │       ├─ domain/
 │       │   ├─ entities/       # Character entity
 │       │   ├─ repositories/   # Repository contracts
 │       │   └─ usecases/       # GetCharacters, Detail, Search, Favorites
 │       └─ presentation/
 │           ├─ bloc/           # HomeBloc, DetailBloc, SearchBloc, FavoritesBloc, FavoritesSyncCubit
 │           ├─ pages/          # HomePage, DetailPage, SearchPage, FavoritesPage
 │           └─ widgets/        # CharacterCard, etc.
 │
 └─ main.dart                 # App bootstrap & router

```
---

## APK Link
Upload APK to Google Drive and paste the share link below:

Google Drive Folder (APK):
https://drive.google.com/drive/u/4/folders/10PINeXvTqTORjC_pQBDlYEbJlmDjqnl0

---

## How to Run
```bash
flutter pub get
flutter run
Build release APK:

bash
Copy code
flutter clean
flutter pub get
flutter build apk --release
Output:

text
Copy code
build/app/outputs/flutter-apk/app-release.apk
Testing
Run all tests:

bash
Copy code
flutter test
Disclaimer
This application is built solely for a take-home challenge purpose.
Rick and Morty API and characters are used for educational and evaluation purposes only.
This is NOT an official Rick and Morty application.
