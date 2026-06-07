# GalleryApp

A basic photo gallery iOS app that fetches online images with **pagination**, persists them in a **local database (Core Data)**, and lets the user **view images offline**. Built with **UIKit + MVVM**.

> Images are fetched from the free [Lorem Picsum](https://picsum.photos) API.

---

## ✨ Features

- **Online image list** — grid of wallpapers/photos from the Picsum API.
- **Pagination** — next page loads automatically as you scroll to the bottom.
- **Pull to refresh** — reloads the list from page 1.
- **Offline persistence** — photo metadata is saved in **Core Data**; downloaded images are cached on disk by Kingfisher, so the gallery is fully viewable **without internet** (for items already loaded once).
- **Full-screen viewer** — tap a photo to open it full screen with pinch / double-tap **zoom**.
- **Skeleton loading** — animated gradient skeleton (SkeletonView) while images load.
- **Login with Google** and a **Profile page with logout**

---

## 🏗️ Architecture

The app follows **MVVM** with a clean separation between the UI, business logic, and data layers.

```
View (UIViewController / Cell)
        │  bindings (closures)
        ▼
ViewModel (GalleryViewModel)
        │
        ├──► Service layer ──► PhotoService (Alamofire)   → network
        │
        └──► PhotoManager ──► PhotoDataRepository ──► PersistentStorage (Core Data)  → offline DB
```

### Layers
| Layer | Responsibility |
|-------|----------------|
| **View** (`GalleryVC`, `PhotoCell`, `PhotoDetailVC`) | UI only, binds to the ViewModel |
| **ViewModel** (`GalleryViewModel`) | Pagination state, loading logic, exposes `photos` + callbacks |
| **Service** (`PhotoService`) | Network calls via Alamofire (`async/await`) |
| **Manager** (`PhotoManager`) | Facade over the data repository |
| **Repository** (`PhotoDataRepository`) | CRUD on Core Data, hides persistence details |
| **Persistence** (`PersistentStorage`) | Core Data stack + background-context saves |

### Design patterns used
- **MVVM** — UI ⇄ ViewModel via closures (`reloadCollection`, `showError`).
- **Repository pattern** — `PhotoRepository` protocol abstracts the data source.
- **Facade** — `PhotoManager` gives the ViewModel a simple storage API.
- **Singleton** — `PersistentStorage.shared`, `PhotoService.shared`.
- **Dependency abstraction via protocols** — easy to mock/test.

### Offline strategy
- **Core Data** stores the photo **list/metadata** (id + URL) → drives the gallery offline.
- **Kingfisher disk cache** stores the actual **image bytes** → renders offline after restart.
- On launch the app shows cached data first (offline-first), then refreshes from the API.
- Writes happen on a **background Core Data context** (`performBackgroundTask`) so the UI never blocks.

---

## 📁 Project structure

```
GalleryApp/
├── Application/            # AppDelegate, SceneDelegate
├── Core/
│   ├── Extenstion/         # Encodable, ScrollView helpers
│   ├── Models/             # BaseResponse, MetaData
│   └── OfflineStorage/
│       ├── CoreDataSupportFiles/   # CDPhoto, PersistentStorage
│       ├── Manager/                # PhotoManager
│       └── Repository/             # PhotoDataRepository
└── Features/
    └── Splash/
    └── Login/
    ├── Gallery/            # GalleryVC, GalleryVM, PhotoCell, Photo, PhotoService
    ├── PhotoDetail/        # PhotoDetailVC (full-screen + zoom)
    └── Profile/
```

---

## 🧩 Dependencies

All third-party libraries are managed with **Swift Package Manager** (already pinned in the project).

| Library            | Version | Purpose                                                                                       |
| ------------------ | ------- | --------------------------------------------------------------------------------------------- |
| Alamofire          | 5.0.0+  | Network layer for API requests, response handling, multipart uploads, and request management. |
| Kingfisher         | 7.0.0+  | Efficient image downloading, caching, and displaying remote images.                           |
| GoogleSignIn       | 7.1.0+  | Google authentication and user sign-in integration.                                           |
| Reachability.swift | 5.2.4+  | Internet connectivity monitoring and network status detection.                                |
| SkeletonView       | 1.0.0+  | Skeleton loading animations while data is being fetched.                                      |
| Toast-Swift        | 5.0.0+  | Lightweight toast notifications for displaying quick user messages.                           |


> No CocoaPods are required — open the project and SPM resolves the packages automatically.

---

## 🚀 Getting started

### Requirements
- Xcode 14+
- iOS 14.0+ deployment target
- Swift 5+

### Run
1. Clone the repo:
   ```bash
   git clone <your-repo-url>
   cd GalleryApp
   ```
2. Open **`GalleryApp.xcodeproj`**.
3. Wait for Swift Package Manager to resolve dependencies (Alamofire, Kingfisher, SkeletonView).
4. Select a simulator/device and press **Run** (⌘R).

### Testing offline mode
1. Run the app **online** once so photos load (saved to Core Data + Kingfisher disk cache).
2. **Quit** the app.
3. Go offline — turn off the Mac's Wi-Fi, or mobile internet data.
4. Relaunch — the previously loaded photos should still appear.

---

## 🌐 API

- **Endpoint:** `GET https://picsum.photos/v2/list?page={page}&limit={limit}`
- Returns a JSON array of photos; the app uses `id` (to build a sized thumbnail URL) and `download_url`.

---

## 👤 Author

Vikram Parmar

