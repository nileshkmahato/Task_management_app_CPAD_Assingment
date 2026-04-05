# 📌 QuickTask – Task Management App

A simple and intuitive cross-platform task management application built using **Flutter** and **Back4App (Parse Server)**. QuickTask allows users to manage their daily tasks efficiently with features like authentication, task tracking, editing, and deletion.

---

## 🚀 Overview

QuickTask is designed to help users organize their tasks with a clean UI and seamless user experience. Each user gets a personalized dashboard where they can manage their tasks privately.

---

## ✨ Features

### 🔐 User Authentication
- Sign up and login functionality
- Secure authentication using Back4App (Parse)
- Personalized task dashboard for each user

### 📝 Task Management
- Create tasks with:
  - Title
  - Due date
- View all tasks in a dashboard

### ✏️ Task Editing
- Modify task title and due date
- Easy access with edit button

### ✅ Task Completion & Deletion
- Mark tasks as completed
- Delete completed tasks

### 👤 User-Specific Dashboard
- Tasks are filtered per logged-in user
- Ensures complete privacy

### 🎨 UI/UX Enhancements
- Clean and intuitive interface
- Background images for better visual experience
- Responsive design (Web + Android)

---

## 🔄 User Flow

### 1. Sign Up / Login
- Users can register or log in from the home screen

### 2. Task Dashboard
- View all tasks
- Options to:
  - Edit
  - Complete
  - Delete

### 3. Add Task
- Floating Action Button (FAB)
- Enter title and due date

### 4. Edit & Complete Task
- Edit task details
- Mark as complete (strikethrough effect)

### 5. Delete Task
- Delete option appears after task completion

---

## 🛠️ Tech Stack

| Layer        | Technology |
|-------------|-----------|
| Frontend    | Flutter |
| Language    | Dart |
| Backend     | Back4App (Parse Server) |
| Database    | Parse Database |
| SDK         | Parse SDK |
| Tools       | VS Code |
| Others      | Intl (date formatting) |

---

## 🧱 Technical Architecture

### Frontend
- Built using Flutter (single codebase for Web & Android)
- Key widgets used:
  - `TextField`
  - `ListView`
  - `FloatingActionButton`
  - `FutureBuilder`

### Backend
- Back4App handles:
  - User authentication
  - Data storage
- Parse SDK integration for API communication

### Data Handling
- Tasks are linked to users
- Query-based filtering ensures:
  - User-specific data access
  - Privacy and isolation

---

## ⚙️ Development Process

1. **Flutter Setup**
   - Initialized project
   - Added dependencies (Parse SDK, UI packages)

2. **Authentication Integration**
   - Login & signup using Parse User

3. **Task Features Implementation**
   - Create, edit, delete tasks
   - Link tasks to users

4. **User-Specific Data**
   - Fetch tasks based on logged-in user

5. **UI Design**
   - Background images
   - Clean layouts and responsive screens

---

## ⚠️ Challenges Faced

### 1. User-Specific Task Filtering
- Ensuring users only see their own tasks  
- Solved by linking tasks with user IDs

### 2. UI Consistency
- Maintaining consistent design across screens  
- Solved using proper layout structures and Flutter widgets

---

## 📂 Project Structure (Suggested)
```bash
lib/
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── dashboard_screen.dart
│   └── edit_task_screen.dart
├── services/
│   └── parse_service.dart
├── models/
│   └── task_model.dart
├── widgets/
│   └── task_tile.dart
└── main.dart
```
🔗 Repository

👉 GitHub:
https://github.com/nileshkmahato/Task_management_app_CPAD_Assingment

🎥 Demo Video

👉 Watch Demo:
https://youtu.be/rMOT3IedDw4

📸 Screenshots

Add your screenshots here (Login, Dashboard, Add Task, Edit Task, etc.)

🧪 Future Improvements
Push notifications for due tasks
Task categories / tags
Dark mode support
Offline support
Priority levels
🙌 Conclusion

QuickTask demonstrates how to build a full-stack Flutter application with backend integration using Back4App. It provides a strong foundation for scalable task management systems with user authentication and personalized experiences.
