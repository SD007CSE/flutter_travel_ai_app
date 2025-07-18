# Flutter Travel AI App

A **Flutter** mobile application for **AI-powered travel recommendations**, itinerary planning, and destination management. This app helps users discover, plan, and manage their travel experiences with the help of an integrated AI assistant.

---

## ✨ Features

- **AI Travel Recommendations:** Get personalized destination suggestions powered by Gemini AI.
- **Itinerary Management:** Create, edit, and manage daily travel plans.
- **Destination Search:** Browse and search for hotels, attractions, and more.
- **Responsive UI:** Built with Flutter’s Material Design for a seamless experience on Android and iOS.
- **Modular Architecture:** Clean, scalable code structure for easy extension and maintenance.

---

## 🏗️ Architecture Overview

The app follows a layered, modular architecture for clarity and scalability:

| Layer         | Directory      | Purpose                                     |
|---------------|---------------|---------------------------------------------|
| **UI**        | `/lib/screens` | Main app screens (Home, Search, AI, etc.)   |
| **Widgets**   | `/lib/widgets` | Reusable UI components                      |
| **Models**    | `/lib/models`  | Data models (Destination, Hotel, Itinerary) |
| **Services**  | `/lib/services`| API calls & AI integration                  |
| **State**     | `/lib/providers`| State management (e.g., ChangeNotifier)      |
| **Utils**     | `/lib/utils`   | Constants, helpers, utility functions       |

**Data Flow Example:**  
User requests recommendations → AI screen → Provider → AI Service → Gemini API → Response parsed → UI updates with recommendations.

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (latest stable version)
- **Dart SDK**
- **Android Studio / Xcode** (for native builds)
- **Gemini API key** (for AI features)

### Steps

1. **Clone the repository**
git clone https://github.com/SD007CSE/flutter_travel_ai_app.git
cd flutter_travel_ai_app

text
2. **Install dependencies**
flutter pub get

text
3. **Set up environment variables**
- Create a `.env` file in the root directory.
- Add your Gemini API key:
  ```
  GEMINI_API_KEY=your_api_key_here
  ```
4. **Run the app**
flutter run

text

---

## 📂 Project Structure

flutter_travel_ai_app/
├── android/ # Android-specific files
├── ios/ # iOS-specific files
├── lib/ # Main Dart source code
│ ├── main.dart # App entry point
│ ├── screens/ # Feature screens
│ ├── models/ # Data models
│ ├── services/ # API & AI services
│ ├── widgets/ # Reusable widgets
│ ├── providers/ # State management
│ └── utils/ # Utilities
├── assets/ # Static resources (images, fonts)
├── test/ # Automated tests
├── pubspec.yaml # Dependencies & metadata
└── README.md # Project documentation

text

---

## 🛠️ API Development & Testing

- **Postman** and **curl** are recommended for testing APIs, especially user registration flows[1].
- The app uses **HTTP clients** (e.g., `http` package) for remote data fetching.

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request.  
For major changes, please open an issue first to discuss your proposed changes.

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

**⭐ Star the repo if you find it useful!**  
Questions or feedback? Open an issue or reach out via GitHub.
