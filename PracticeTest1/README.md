# Student Management App - Code Explanation

Hi Ms. Phượng, my name is Võ Châu Anh. Below is a short and simple explanation of how I designed the Classes and handled the main logic for this practice test 1.

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

**Student View**

<img src="https://github.com/user-attachments/assets/6f03ca62-4f0d-4a0a-b4f7-bd27133fe1f2" width="350" />

**Student Detail View**

<img src="https://github.com/user-attachments/assets/961a8b11-a5f4-450a-83f5-2cf92952a41e" width="350" />

**Edit Mark View**

<img src="https://github.com/user-attachments/assets/928d76da-2243-4e82-88ca-0260a4a73997" width="350" />

- *After edit mark: iOS Programming from 9.0 -> 8.5*
  
<img src="https://github.com/user-attachments/assets/3e1a434e-267a-46d4-a970-44ed15962bb9" width="350" />

**Subject View**

<img src="https://github.com/user-attachments/assets/96221f14-87a6-46b4-adc0-1d9db8e6a856" width="350" />

**Academic Result View**

<img src="https://github.com/user-attachments/assets/64265a23-2142-4044-b887-32fef5ceb9db" width="350" />
