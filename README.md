# 🏥 Medora - Pharmacy Management App

🚀 **Medora** is a **full-stack pharmacy management app** built with **Flutter & Firebase** to digitize pharmacy operations.

---

## 📌 Features

👉 **User Authentication** (Register/Login with Firebase Auth)  
👉 **Pharmacy Management** (Add, Edit, Delete Pharmacies)  
👉 **Medicine Management** (Add, Edit, Delete Medicines for each Pharmacy)  
👉 **Advanced Search & Filtering** (Find medicines & pharmacies quickly)  
👉 **Firestore Database Integration** (Data stored in Firebase)  
👉 **Responsive UI with Material Design**

---

## 📌 Tech Stack

🔹 **Frontend:** Flutter (Dart)  
🔹 **Backend:** Firebase Firestore (NoSQL Database)  
🔹 **Authentication:** Firebase Auth  
🔹 **State Management:** setState & StreamBuilder  
🔹 **Tools:** Android Studio, GitHub

---

## 📌 Installation Guide

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/ChetandeepSingh/medora.git
cd medora
```

### **2️⃣ Install Dependencies**
```bash
flutter pub get
```

### **3️⃣ Run the App**
```bash
flutter run
```
*(Ensure an emulator or real device is connected.)*

---

## 📌 Generating an APK

To build an **installable APK**, run:
```bash
flutter build apk --release
```
The APK will be saved in:
```
/build/app/outputs/flutter-apk/app-release.apk
```

---

## 📌 Firebase Configuration

1. **Go to Firebase Console**
2. **Create a Firebase Project** (if not already set up)
3. **Enable Authentication & Firestore Database**
4. **Download `google-services.json`** and place it inside:
   ```
   android/app/google-services.json
   ```
5. **Run the app again** using `flutter run`

---

## 📌 Folder Structure

```
📂 medora/
 └📂 lib/
     └📂 screens/            # UI Screens
         ├📄 home_screen.dart
         ├📄 pharmacy_list_screen.dart
         ├📄 medicine_list_screen.dart
         ├📄 profile_screen.dart
         ├📄 login_screen.dart
         ├📄 register_screen.dart
     ├📄 main.dart              # Entry Point
 ├📂 android/                # Android Native Config
 ├📂 ios/                    # iOS Native Config
 ├📂 assets/                 # Images, Icons, Fonts
 ├📄 pubspec.yaml               # Flutter Dependencies
 ├📄 README.md                  # Project Documentation
 ├📄 .gitignore                  # Ignored Files
 ├📄 key.properties              # Firebase Keys (Not to be pushed!)
 ├📂 build/                      # Generated APK (ignored)
```

---

## 📌 Contribution Guidelines

🛠 Want to contribute? Follow these steps:

1. **Fork the Repository**
2. **Create a New Branch**
   ```bash
   git checkout -b feature-branch
   ```
3. **Make Your Changes & Commit**
   ```bash
   git commit -m "Added new feature"
   ```
4. **Push to GitHub & Submit PR**
   ```bash
   git push origin feature-branch
   ```

