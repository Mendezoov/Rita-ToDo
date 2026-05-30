# Rita To-Do List

A clean and modern iOS task manager app built with SwiftUI and SwiftData.

## Features

- **Onboarding Screen** — animated gradient background with floating emojis on first launch
- **Task Management** — add, edit, and delete tasks with a title and optional notes
- **Swipe to Delete** — swipe left on any task to remove it instantly
- **Multi-Select** — long press or tap tasks to select multiple, then bulk delete
- **Persistent Storage** — tasks saved locally using SwiftData (no account needed)
- **Light & Dark Mode** — fully adaptive UI for both color schemes
- **Liquid Glass UI** — modern iOS 26 glass effects on buttons and input fields

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Database:** SwiftData
- **Architecture:** MVVM
- **Minimum Target:** iOS 26+

## Project Structure

```
DataBaseCapstone/
├── DataBaseCapstoneApp.swift       # App entry point, SwiftData model container setup
├── ContentView.swift               # Root view, onboarding gate
├── Models/
│   └── TodoItem.swift              # SwiftData model (id, title, notes, isCompleted, createdAt)
├── ViewModels/
│   └── TodoViewModel.swift         # Business logic for CRUD operations and selection state
└── Views/
    ├── TodoListView.swift           # Main task list with toolbar and add button
    ├── TodoRowView.swift            # Individual task row with checkbox and selection
    ├── AddEditTodoView.swift        # Sheet for creating or editing a task
    └── OnboardingView.swift         # First-launch welcome screen
```

## Getting Started

1. Clone the repo
2. Open `DataBaseCapstone.xcodeproj` in Xcode
3. Select a simulator or connected device running iOS 26+
4. Build and run (`Cmd + R`)

## Author

Mendez — [github.com/Mendezoov](https://github.com/Mendezoov)
