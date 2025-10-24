# 🎥 Flutter Video Upload App with FCM Push Notifications

A modern Flutter application demonstrating **video recording & upload**, **Firebase Cloud Messaging (FCM) push notifications**, and **secure authentication** — built with production-minded architecture.

---

## 🚀 Features

✅ **User Authentication** (Login / Registration)  
✅ **FCM Push Notifications** (via Firebase Cloud Messaging)  
✅ **Record & Upload Videos** (camera + file upload)  
✅ **REST API Integration** (with Dio & custom backend)  
✅ **State Management** using Riverpod  
✅ **Secure Token Handling** (with Flutter Secure Storage)  
✅ **Clean, Scalable Folder Structure**

---

## 🧱 Project Structure

lib/
│
├── core/
│ ├── services/ # API client, secure storage, etc.
│ ├── utils/ # App routes, constants
│ └── models/ # Common data models
│
├── features/
│ ├── auth/ # Login & registration
│ ├── home/ # Home screen + logout
│ ├── video/ # Video recording & upload
│ └── notifications/ # Push notification handling
│
└── main.dart # Entry point

yaml
Copy code

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-------------|
| Frontend | Flutter (Dart) |
| State Management | Riverpod |
| API Client | Dio |
| Backend (for demo) | Node.js / Express |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Storage | Flutter Secure Storage + Firestore (optional) |

---

## ⚙️ Setup Instructions

1️⃣ **Clone this repository**
```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
2️⃣ Install dependencies

bash
Copy code
flutter pub get
3️⃣ Set up Firebase

Add your google-services.json (Android)

Add your GoogleService-Info.plist (iOS)

Enable FCM in Firebase Console

4️⃣ Run the app

bash
Copy code
flutter run
🔐 Environment Variables (Example)
If you use .env or config constants:

env
Copy code
API_BASE_URL=https://your-api-url.com
FCM_SERVER_KEY=your-fcm-server-key
📸 Screenshots (optional)
Add screenshots here for login, home, and video upload screens
Example:


🧑‍💻 Author
Sunny
💼 Flutter Developer
🔗 GitHub Profile

📝 License
This project is licensed under the MIT License — see the LICENSE file for details.

⭐ Show Your Support
If you found this project helpful, please consider giving it a ⭐ star on GitHub!
