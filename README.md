# Student Management App - Code Explanation

Hi Ms. Phượng, my name is Võ Châu Anh. Below is a short and simple explanation of how I designed the Classes and handled the main logic for this assignment.

## 1. Class Design
I split the problem into 3 separate classes for easy management:
- **`Student`**: Stores student information (ID, name, age).
- **`Subject`**: Stores subject information (ID, name, credits).
- **`StudentRecord`**: Acts as a transcript linking `Student` and `Subject`. It contains the `mark` and `academicYear`.

## 2. Business Logic

### Weighted Average
Because subjects have different credit values, I calculate the average using weights. Subjects with more credits will have a bigger impact on the final score.
*   **Formula**: `Sum(Mark * Credits) / Total Credits`.
*   **Code (`SchoolManager.swift`)**:
    ```swift
    let weighted = rs.reduce(0.0) { $0 + $1.getMark() * Double($1.subject.getCredits()) }
    let credits  = rs.reduce(0.0) { $0 + Double($1.subject.getCredits()) }
    return credits > 0 ? weighted / credits : nil
    ```

### Academic Ranking
Based on the calculated average, I use `if-else` statements to compare it with the required thresholds:
*   `>= 8.5`: Excellent
*   `>= 7.0`: Good
*   `>= 5.0`: Average
*   `< 5.0`: Fail

### Pass / Fail Check
According to the business rule, a student passes a subject if their mark is **`>= 5.0`**.
*   The `isPassed()` function in `StudentRecord` simply returns `true` or `false`.

## 3. Data Validation

### Preventing marks outside 0 - 10
In the `setMark()` function of the `StudentRecord` class, I use a `guard` statement to check the input. If the mark is invalid, the app throws an `invalidMark` error and prevents it from being saved.
```swift
guard (0.0...10.0).contains(newMark) else {
    throw AcademicError.invalidMark(newMark)
}
```

### Preventing duplicate subject registration
In the `register()` function of `SchoolManager`, before adding a new record, I check if the student already has a `StudentRecord` with the same `studentID`, `subjectID`, and `academicYear`. If it exists, it throws a duplicate error.

## 4. SwiftUI & Interaction (Tasks 4 & 5)

- **UI Display**: I use a `TabView` with 3 tabs (Students, Subjects, Ranking). Each student row displays their average mark and rank badge right away.
- **Updating Marks**: Tapping a record opens the `EditMarkView` popup to input a new mark.
- **Refresh Mechanism**: 
    - The `StudentRecord` class inherits from `ObservableObject`, and the `mark` property is marked with `@Published`. 
    - Therefore, as soon as "Save" is hit, the UI (mark, pass/fail status, average, and ranking) **updates instantly** without needing to reload the app.
    - Additionally, the lists support pull-to-refresh (`.refreshable`) for manual updates.
 
---
## Screenshots
Below are the screenshots showing its UI and features.

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-10-19 at 10 32 36" src="https://github.com/user-attachments/assets/0afa02d1-7d8a-4038-bbab-4c9fc8546143" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-10-19 at 10 32 44" src="https://github.com/user-attachments/assets/f39371d7-2642-423f-954f-99818b83dbb6" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-10-19 at 10 32 58" src="https://github.com/user-attachments/assets/a9b75684-9d0c-487e-ac96-092d8cf8b774" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-10-19 at 10 33 15" src="https://github.com/user-attachments/assets/8198cea8-9563-4b73-ac34-b25713f2589e" />

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-10-19 at 10 33 37" src="https://github.com/user-attachments/assets/a74ce592-8d43-42c5-9fb7-2dab13a6182d" />

