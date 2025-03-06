# 📖 Easy Dictionary App  
A Flutter-based dictionary app that allows users to search for word definitions, listen to pronunciations, and view the word of the day.  

## 🚀 Features  
✔️ Search for word definitions using an API  
✔️ Play pronunciation audio  
✔️ Display "Word of the Day"  
✔️ Cache previous word of the day for offline access  
✔️ Show recent searches with an intuitive UI  
✔️ Handle errors with user-friendly messages  

---

## 🛠️ Tech Stack  
- **Flutter** (Dart)  
- **Provider (State Management)**  
- **REST API** ([Dictionary API](https://api.dictionaryapi.dev/))  
- **AudioPlayers** (For pronunciation playback)  
- **Shared Preferences** (For caching recent searches)  

---

## 📂 Project Structure (MVVM)  



---

## 🚀 Features  

✔️ **Search for word definitions** using an API  
✔️ **Play pronunciation audio**  
✔️ **Display "Word of the Day"**  
✔️ **Cache previous Word of the Day** for offline access  
✔️ **Show recent searches** with an intuitive UI  
✔️ **Error handling** with user-friendly messages  

---

## 🛠️ Tech Stack  

- **Flutter (Dart)**  
- **Provider (State Management)**  
- **REST API** ([Dictionary API](https://api.dictionaryapi.dev/))  
- **AudioPlayers (For pronunciation playback)**  
- **Shared Preferences (For caching searches & word of the day)**  

---

## 📸 Screenshots  

| Home Screen | Word Details | Blog |
|-------------|-------------|-------------|
|<img width="305" alt="image" src="https://github.com/user-attachments/assets/349f0ad8-31ab-4d8b-a192-0a96f0f527d0" /> | <img width="305" alt="image" src="https://github.com/user-attachments/assets/c410ddde-96b2-43dc-a630-6d080490011a" /> | <img width="305" alt="image" src="https://github.com/user-attachments/assets/8a493789-f2fb-4d4f-a186-17296ce6f7f5" />

---

## 📦 Installation & Setup  

1️⃣ **Clone the repository**  
```sh
git clone https://github.com/yourusername/easy-dictionary.git
cd easy-dictionary
```
2️⃣ **Install Dependencies**  
```sh
flutter pub get
```
3️⃣ **Run the app**
```sh
flutter run
```
## 📡 API Usage  

This app fetches word definitions from the **[Dictionary API](https://api.dictionaryapi.dev/)**.

### 🔍 Example API Call  
```http
GET https://api.dictionaryapi.dev/api/v2/entries/en/example
```

## 📴 Offline Mode & Error Handling  

This app ensures a smooth user experience even when offline by implementing caching and error handling mechanisms.

### 🛠 Offline Caching  
- The **Word of the Day** is cached to be displayed when there is no internet.  
- **Recent Searches** are stored locally to allow access without an internet connection.  
- **Shared Preferences** or a local database (like Hive) can be used for persistent storage.

### ❌ Error Handling  
Different error cases and their handling strategies:

| Error Scenario                     | User Message                                      | Handling Strategy |
|-------------------------------------|--------------------------------------------------|------------------|
| No Internet Connection             | "You're offline. Showing saved data."            | Show cached data |
| API Request Fails                   | "Couldn't fetch data. Please try again later."  | Retry mechanism |
| Word Not Found                      | "Word not found. Try another word!"             | Display fallback UI |
| Audio Playback Fails (No Internet)  | "Cannot play audio. Check your connection."     | Show error toast |

---

## 🤝 Contributing  

We welcome contributions from the community! Follow these steps to contribute:

### 🏗 Steps to Contribute  
1. **Fork** this repository.  
2. **Clone** your forked repository:
```sh
git clone https://github.com/your-username/repo-name.git
```
3. **Create** a new branch for your feature:
```sh
git checkout -b feature-name
```
4. **Make your changes** and commit
```sh
git commit -m "Add feature-name"
```
5. **Push to github**
```sh
git push origin feature-name
```
## 📝 Contribution Guidelines  

Thank you for your interest in contributing to this project! 🎉  
Please follow the guidelines below to ensure a smooth collaboration.

---

### 🔧 Code Standards  
✅ Follow the **MVVM (Model-View-ViewModel) architecture** for code structure.  
✅ Use meaningful variable and function names.  
✅ Maintain **consistent indentation** and formatting.  
✅ Avoid **hardcoded values**; use constants or localization where applicable.  
✅ Ensure all **API calls are handled properly**, including error states.  

---

### 🎨 UI/UX Best Practices  
✅ Keep the **design consistent** with the existing theme.  
✅ Use **responsive layouts** to support different screen sizes.  
✅ Follow **Material Design** guidelines where applicable.  
✅ Ensure smooth **animations and transitions** for better user experience.  
✅ Handle **empty states and loading indicators** properly.  

---

### 🐞 Bug Fixing & Debugging  
✅ Clearly describe the issue in **commit messages** and **pull requests**.  
✅ Always test on multiple devices/emulators before submitting a fix.  
✅ Provide **reproducible steps** if reporting a bug.  
✅ Ensure error messages are **clear and helpful** to users.  

---

