# Google Sans Flex Font Setup

To fully implement Google Sans Flex font in the StoryStudio app, follow these steps:

## 1. Download Google Sans Flex Font Files

Google Sans Flex is a variable font family. You can download it from:
- Google Fonts: https://fonts.google.com/specimen/Google+Sans
- Or from Google's official design resources

Download the following font files (if available):
- GoogleSansFlex-Regular.ttf
- GoogleSansFlex-Medium.ttf
- GoogleSansFlex-SemiBold.ttf
- GoogleSansFlex-Bold.ttf

## 2. Add Font Files to Xcode Project

1. In Xcode, right-click on the `StoryStudio` folder in the project navigator
2. Select "Add Files to StoryStudio..."
3. Navigate to the downloaded font files and select them
4. Make sure to check:
   - ✅ "Copy items if needed"
   - ✅ "Create groups"
   - ✅ Target: StoryStudio

## 3. Add Fonts to Info.plist

Since this project uses `GENERATE_INFOPLIST_FILE = YES`, you need to add the font configuration in the project settings:

1. Select the StoryStudio project in the navigator
2. Select the StoryStudio target
3. Go to the "Info" tab
4. Add a new key: `Fonts provided by application` (Array)
5. For each font file, add an item with the filename:
   - Item 0: `GoogleSansFlex-Regular.ttf`
   - Item 1: `GoogleSansFlex-Medium.ttf`
   - Item 2: `GoogleSansFlex-SemiBold.ttf`
   - Item 3: `GoogleSansFlex-Bold.ttf`

## 4. Update Font Extension

Open `StoryStudio/Utils/Font+Extensions.swift` and replace the placeholder with the actual custom font:

```swift
static func googleSansFlex(size: CGFloat, weight: Font.Weight = .regular) -> Font {
    let fontName: String
    switch weight {
    case .bold:
        fontName = "GoogleSansFlex-Bold"
    case .semibold:
        fontName = "GoogleSansFlex-SemiBold"
    case .medium:
        fontName = "GoogleSansFlex-Medium"
    case .light:
        fontName = "GoogleSansFlex-Light" // if available
    default:
        fontName = "GoogleSansFlex-Regular"
    }
    return .custom(fontName, size: size)
}
```

## 5. Verify Font Installation

To verify the fonts are loaded correctly, you can add this debug code temporarily:

```swift
UIFont.familyNames.forEach { familyName in
    let fontNames = UIFont.fontNames(forFamilyName: familyName)
    print("Family: \(familyName) Font names: \(fontNames)")
}
```

## Current State

The app currently uses `.system(size:weight:design: .rounded)` as a placeholder for Google Sans Flex. The font extension in `Font+Extensions.swift` provides a consistent API that can be easily switched to the actual custom font once the font files are added.

All views have been updated to use the `.googleSansFlex()` extension, so once you add the actual font files and update the extension, the entire app will use Google Sans Flex.
