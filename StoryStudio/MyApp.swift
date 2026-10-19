import SwiftUI
import CoreText

@main
struct StoryStudioApp: App {
    init() {
        guard let fontURL = Bundle.main.url(
            forResource: "GoogleSansFlex",
            withExtension: "ttf"
        ) else {
            preconditionFailure("Google Sans Flex font is missing from the app bundle.")
        }

        var registrationError: Unmanaged<CFError>?
        guard CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &registrationError) else {
            let error = registrationError?.takeRetainedValue()
            preconditionFailure("Google Sans Flex font registration failed: \(String(describing: error))")
        }
    }

    var body: some Scene {
        WindowGroup {
            OnboardingFlow()
                .font(.googleSansFlex(.body))
        }
    }
}
