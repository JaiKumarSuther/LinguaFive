# Error Screenshots Guide

## 📸 Required Screenshots for Academic Submission

This directory should contain error screenshots demonstrating the debugging and problem-solving process during LinguaFive development.

---

## 📋 Screenshot Checklist

### ✅ Required Error Screenshots

#### 1. Overflow Errors (3 screenshots)
- [ ] `overflow-error-dashboard.png` - Dashboard screen with RenderFlex overflow
- [ ] `overflow-error-today.png` - Today's words screen overflow
- [ ] `overflow-error-quiz.png` - Quiz screen overflow

**How to Capture**:
1. Run app on small screen emulator (e.g., Pixel 5, 360x800)
2. Navigate to dashboard/today/quiz screens
3. Let the overflow error appear (red/yellow stripes)
4. Screenshot the error message in debug console and UI

**What to Show**:
- Red and yellow striped overflow indicator
- Error message in debug console
- Screen name visible
- Affected widgets highlighted

---

#### 2. Word Search Game Not Working (1 screenshot)
- [ ] `word-search-not-working.png` - Word search showing but no interaction

**How to Capture**:
1. Navigate to Practice → Word Search
2. Try to drag/select words (nothing happens)
3. Screenshot the static grid without selection highlights
4. Optionally: Add arrows/annotations showing "tried to drag here"

**What to Show**:
- Word search grid displayed
- No selection feedback
- Words list visible but nothing selected

---

#### 3. Compilation Errors (1 screenshot)
- [ ] `compilation-error-brackets.png` - Syntax errors with brackets

**How to Capture**:
1. Open terminal/Problems panel in VS Code or Android Studio
2. Show the bracket/parenthesis error messages
3. Highlight the file paths and line numbers

**What to Show**:
```
Error: Expected ']' but found '}'
lib/features/dashboard/dashboard_screen.dart:123:45
Error: Expected ')' but found EOF
lib/features/quiz/quiz_screen.dart:456:12
```

---

#### 4. TTS Chinese Error (1 screenshot)
- [ ] `tts-chinese-error.png` - Text-to-Speech error for Chinese

**How to Capture**:
1. Select Chinese language
2. Navigate to Pronunciation Practice
3. Tap the speaker icon for a Chinese word
4. Screenshot the error or no sound output
5. Show debug console with TTS error

**What to Show**:
- Chinese word visible
- Speaker/volume icon tapped
- Error message if available
- Debug console showing TTS language code issue

---

#### 5. Password Validation Error (1 screenshot)
- [ ] `password-validation-error.png` - Generic password error

**How to Capture**:
1. Go to signup screen
2. Enter weak password (e.g., "pass")
3. Try to submit
4. Screenshot the generic error without requirements shown

**What to Show**:
- Signup form
- Weak password entered
- Error message: "Password must be at least 8 characters" (generic)
- No visual requirements checklist

---

#### 6. Data Not Persisting (1 screenshot)
- [ ] `data-not-persisting.png` - Progress lost after restart

**How to Capture**:
1. Learn some words (mark as learned)
2. Screenshot showing progress (e.g., "5 words learned today")
3. Close and restart app
4. Screenshot showing reset progress (0 words learned)
5. Use side-by-side comparison

**What to Show**:
- Before: Progress shown (screenshot 1)
- After: Progress reset to 0 (screenshot 2)
- Timestamps if possible

---

#### 7. PowerShell Command Error (1 screenshot)
- [ ] `powershell-command-error.png` - Command separator error

**How to Capture**:
1. Open PowerShell terminal
2. Run: `cd lingua-five-frontend && flutter pub get`
3. Screenshot the error message

**What to Show**:
```
PS C:\...\linguafive> cd lingua-five-frontend && flutter pub get
At line:1 char:28
+ cd lingua-five-frontend && flutter pub get
+                         ~~
The token '&&' is not a valid statement separator in this version.
```

---

#### 8. Streak Calculation Wrong (1 screenshot)
- [ ] `streak-calculation-wrong.png` - Incorrect streak number

**How to Capture**:
1. Use app for multiple consecutive days
2. Screenshot dashboard showing wrong streak (e.g., 0 when should be 3)
3. Show date and expected vs actual streak

**What to Show**:
- Dashboard with streak counter
- Current date visible
- Incorrect streak number circled/highlighted
- Expected streak annotated

---

#### 9. Build Runner Error (1 screenshot)
- [ ] `build-runner-error.png` - Hive adapter generation error

**How to Capture**:
1. Open terminal
2. Run: `flutter packages pub run build_runner build`
3. Screenshot the error message

**What to Show**:
```
[SEVERE] Conflicting outputs were detected. Please run 
`flutter packages pub run build_runner clean` to remove them.
```

---

## 🎨 Screenshot Formatting Tips

### Quality Standards
- **Resolution**: At least 1920x1080 for desktop, native for mobile
- **Format**: PNG (lossless, better for text)
- **Visibility**: Ensure error text is readable
- **Context**: Include enough context to understand the problem

### Annotation Tips
Use image editing tools to add:
- 🔴 Red circles around error messages
- ➡️ Arrows pointing to problem areas
- 📝 Text annotations explaining the issue
- ⏰ Timestamps showing when error occurred

### Tools to Use

#### Windows
- **Snipping Tool** (Win + Shift + S)
- **Game Bar** (Win + G) for app screenshots
- **Paint** or **Paint 3D** for annotations

#### Android Studio / VS Code
- Built-in screenshot tools
- Terminal screenshot feature
- Problems/Console panel capture

#### Mobile Emulator
- Android Emulator: Camera icon or Ctrl + S
- Chrome DevTools: Device toolbar screenshot

---

## 📐 Screenshot Specifications

### Error Console Screenshots
```
Recommended Size: 1920x1080 or 1280x720
Focus: Error messages and stack traces
Include: File paths, line numbers, error types
```

### UI Error Screenshots  
```
Recommended Size: 1080x1920 (mobile portrait)
Focus: Visual error indicators (overflow stripes)
Include: Screen title, affected UI elements
```

### Side-by-Side Comparisons
```
Format: Two screenshots side by side
Labels: "Before Fix" and "After Fix"
or "Expected" and "Actual"
```

---

## 📊 Screenshot Organization

### Naming Convention
Follow the exact names in the checklist:
- Use lowercase with hyphens
- Be descriptive but concise
- Match the references in README.md

### File Structure
```
screenshots/
└── errors/
    ├── overflow-error-dashboard.png
    ├── overflow-error-today.png
    ├── overflow-error-quiz.png
    ├── word-search-not-working.png
    ├── compilation-error-brackets.png
    ├── tts-chinese-error.png
    ├── password-validation-error.png
    ├── data-not-persisting.png
    ├── powershell-command-error.png
    ├── streak-calculation-wrong.png
    └── build-runner-error.png
```

---

## 🎓 Academic Submission Tips

### What Your Teacher Wants to See

1. **Real Errors**: Actual screenshots, not staged
2. **Problem-Solving Process**: Clear before/after comparisons
3. **Technical Understanding**: Error messages with explanations
4. **Debugging Skills**: How you identified root causes
5. **Professional Documentation**: Well-organized, annotated screenshots

### Creating a Strong Submission

#### Do ✅
- Capture actual errors you encountered
- Show error messages clearly
- Add annotations and explanations
- Include timestamps if possible
- Show both error and solution states
- Demonstrate complexity of issues

#### Don't ❌
- Use blurry or small screenshots
- Stage fake errors
- Submit screenshots without context
- Ignore error message details
- Skip annotation of key points
- Use low-quality images

---

## 🚀 Quick Capture Workflow

### Step-by-Step Process

1. **Recreate the Error**
   - Run the app in error state
   - Trigger the specific bug
   - Ensure error is visible

2. **Capture Screenshot**
   - Use appropriate tool (Snipping Tool, Emulator, etc.)
   - Include enough context
   - Capture both UI and console if needed

3. **Annotate (Optional but Recommended)**
   - Open in Paint/Paint 3D
   - Add red circles, arrows, text
   - Highlight key error messages
   - Add "Before" and "After" labels

4. **Save with Correct Name**
   - Use exact name from checklist
   - Save as PNG format
   - Check file size (< 5MB recommended)

5. **Verify in README**
   - Open main README.md
   - Check if image displays correctly
   - Ensure path matches: `screenshots/errors/filename.png`

---

## 📝 Additional Screenshots (Optional)

If you have more errors, add them with descriptive names:
- `error-network-timeout.png`
- `error-null-pointer-exception.png`
- `error-gradle-build-failed.png`

Update the main README.md to include any additional screenshots.

---

## ✅ Final Checklist Before Submission

- [ ] All 11 required screenshots captured
- [ ] Screenshots are clear and readable
- [ ] Error messages are visible
- [ ] Files named correctly (match checklist)
- [ ] PNG format used
- [ ] Annotations added where helpful
- [ ] README.md image references working
- [ ] File sizes reasonable (< 5MB each)
- [ ] Screenshots demonstrate problem-solving
- [ ] Context is clear for each error

---

## 📧 Need Help?

If you encounter issues capturing screenshots:
1. Check Flutter DevTools for error logs
2. Use `flutter run -v` for verbose error output
3. Check Android Studio's Logcat for detailed errors
4. Consult VS Code's Problems panel

---

**Remember**: These screenshots demonstrate your debugging skills and problem-solving ability. Make them clear, professional, and informative!

**Last Updated**: October 26, 2025

